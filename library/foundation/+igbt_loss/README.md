# `pelib.igbt_loss` — IGBT loss model with drift-region tail current

Simscape language component for conduction and switching loss accounting in
hard-switched converters, with the turn-off tail current resolved explicitly.
The freewheeling diode is external.

---

## 1. Scope

**Resolved**

- On-state characteristic `v = Vce0(Tj) + Rce(Tj)·i`, temperature dependent.
- Turn-off tail current from the drift-region excess-carrier decay,
  `i_tail(t) = k_tail·Ic·exp(-(t-t_off)/τ_tail(Tj))`.
- Cumulative `Eon`, `Eoff`, `Err`, conduction energy, instantaneous power.
- Junction thermal port; conduction + tail + switching losses are injected
  into it, so the model closes the loop with a Foster/Cauer network.

**Not resolved**

- The switching transient itself. `dv/dt`, `di/dt`, gate-charge plateau and
  the current overshoot from diode recovery are not simulated; the device
  commutates in one solver step and the associated energy comes from tables.
  This is the standard energy-based approach, and it is what makes the model
  usable at converter timescales.
- Miller capacitance, gate loop dynamics, short-circuit behaviour,
  desaturation, avalanche.

If you need the real transient shape you need a physical model
(Hefner / Kraus type). This one is for losses and junction temperature.

---

## 2. Files and build

```
+pelib/
    igbt_loss.ssc
```

```matlab
cd <folder containing +pelib>
ssc_build pelib          % creates pelib_lib.slx
```

Then drag `pelib.igbt_loss` from `pelib_lib` into the model.
Requires R2019a or later (the `intermediates` block).

---

## 3. Ports

| Port | Type | Meaning |
|---|---|---|
| `C`, `E` | electrical | collector, emitter |
| `H` | thermal | junction node; conduction + tail + switching heat |
| `G` | PS input, V | gate command, ON when `G > Vg_on` |
| `P` | PS output, W | instantaneous total dissipation |
| `Ecnd` | PS output, J | cumulative conduction energy |
| `Eon` | PS output, J | cumulative turn-on energy |
| `Eoff` | PS output, J | cumulative turn-off energy (table residual + explicit tail) |
| `Err` | PS output, J | cumulative recovery energy of the *external* diode |

`Err` is reported only. It is the loss of the companion diode, so it is not
injected into `H`. Feed it to the thermal model of your external diode, or
ignore it if that diode has its own recovery model.

---

## 4. Equations

**Conduction**

```
V0(Tj)  = Vce0·(1 + a_V·(Tj - Tref))          a_V < 0
Rce(Tj) = Rce ·(1 + a_R·(Tj - Tref))          a_R > 0
i_cond  = (v - V0)/Rce      if ON and v > V0
        = v/R_off           otherwise
```

The second branch is what stops the model from sinking a large reverse
current when the external antiparallel diode clamps `v` negative.

**Switching**

```
Eon  = Eon_tab (Ic, Tj)·(Vdc/Vref)^kv_on ·(Rg/Rg_ref)^krg_on
Eoff = Eoff_tab(Ic, Tj)·(Vdc/Vref)^kv_off·(Rg/Rg_ref)^krg_off
Err  = Err_tab (Ic, Tj)·(Vdc/Vref)^kv_rr
```

`Vdc` is the blocking voltage sampled at the gate rising edge, i.e. before
the device shorts it out. `Ic` for `Eoff` is sampled at the falling edge;
`Ic` for `Eon` and `Err` is sampled `t_meas` after the rising edge, once the
load current has commutated into the device. Both use a lightly filtered
current (`tau_smp`) so the sample does not depend on the solver's event
ordering.

**Tail and double counting**

The datasheet `Eoff` is measured to a defined cut-off and therefore already
contains the tail. Since the tail is modelled explicitly here, its analytic
energy is removed from the table value:

```
E_tail = Vdc·k_tail·Ic·τ_tail(Tj)
Eoff_applied = max(Eoff_tab_scaled - E_tail, 0)
```

The reported `Eoff` output adds the measured tail energy back
(`∫ v·i_tail dt`), so it still matches the datasheet while the tail is
visible in the current waveform. `k_tail = 0` disables the tail entirely and
gives a pure table-based turn-off.

**Heat release**

Switching energies are impulses. They are released into the thermal port
through a first-order lag:

```
E_rel' = (Eon_acc + Eoff_acc - E_rel)/τ_rel
P_sw   = (Eon_acc + Eoff_acc - E_rel)/τ_rel
```

Energy is conserved; `τ_rel` only smears it in time. Pick
`τ_rel` between one switching period and the smallest Foster time constant
(default 100 µs).

---

## 5. Parameterizing from a datasheet

1. **Static.** Read `Vce(sat)` vs `Ic` at 25 °C and 125 °C (or 150 °C), gate
   at 15 V. Fit a straight line over your working range:
   `Vce0` = intercept, `Rce` = slope. Then
   `a_V = (Vce0_hot/Vce0_25 - 1)/ΔT`, `a_R = (Rce_hot/Rce_25 - 1)/ΔT`.
   `a_V` is normally negative and `a_R` positive; the crossover is why
   `Vce(sat)` curves cross around 30–50 % of the nominal current.

2. **Switching tables.** Take `Eon`, `Eoff`, `Err` vs `Ic` at both
   temperatures, at the datasheet `Vdc` (`Vref`) and `Rg` (`Rg_ref`). Enter
   them row-wise in `i_tab` order. Keep a zero first row.

3. **Voltage exponents.** If the datasheet gives `E` vs `Vdc`, fit
   `kv = log(E2/E1)/log(V2/V1)`. Typical: `kv_on ≈ kv_off ≈ 1.0…1.3`,
   `kv_rr ≈ 0.5…0.8`. If nothing is given, use 1 for `Eon`/`Eoff`.

4. **Gate resistance exponents.** From the `E` vs `Rg` curve,
   `krg = log(E2/E1)/log(Rg2/Rg1)`. Turn-on is much more sensitive than
   turn-off (defaults 0.45 and 0.12). A power law is used rather than a
   linear correction so the result stays positive for any `Rg`.

5. **Tail.** This is the part the datasheet does not give you directly.
   Read the turn-off oscillogram at nominal current:
   - `k_tail` = (current at the end of the fast fall) / `Ic` — typically
     0.08…0.20 for a field-stop trench IGBT, higher for older PT/NPT parts.
   - `τ_tail` = time for the tail to fall to 37 % — typically 0.3…2 µs at
     25 °C, growing with temperature (`a_tau ≈ 3…6·10⁻³ /K`, since the
     carrier lifetime rises with `Tj`).

   Sanity check: `Vdc·k_tail·Ic·τ_tail` should land at roughly 30–50 % of
   the datasheet `Eoff` at that point. If it exceeds `Eoff`, the model
   clips the residual to zero and your total `Eoff` will come out too high —
   reduce `k_tail` or `τ_tail`.

---

## 6. Validation — double pulse

Build the usual circuit: DC source `Vref`, load inductor, your external
freewheeling diode across the inductor, IGBT low side, a Foster network on
`H` (or a constant temperature source for a first check).

1. **Conduction.** Long first pulse. Check `v` against the datasheet
   `Vce(sat)` at the reached current and at the imposed `Tj`. Check that
   `Ecnd` grows as `Vce·Ic·t`.

2. **Tail.** Zoom on the first turn-off. The current should drop to
   `k_tail·Ic` in one step and then decay with `τ_tail`. The area under
   `v·i_tail` is what you compare against the oscillogram.

3. **Energies.** Run a single on/off pair and read the steps in `Eon` and
   `Eoff`. They must match the datasheet values at that `Ic`, `Vdc`, `Rg`,
   `Tj`, within the interpolation error. This is the test that catches a
   wrong `k_tail`/`τ_tail` combination: `Eoff` is the sum of the table
   residual and the explicit tail, so it should stay on the datasheet curve
   regardless of how you split it.

4. **Temperature loop.** Close the Foster network and check that `Tj` rises
   and that the losses rise with it. If `Tj` falls instead, flip the sign of
   the `Q_h` equation (the convention is flagged in the code).

5. **Average power.** `P` is instantaneous. For a mean value over a
   fundamental period, either low-pass `P` or differentiate the cumulative
   energies over a window. The cumulative outputs are usually the cleaner
   route: `P_avg = (E(t2) - E(t1))/(t2 - t1)`.

---

## 7. Things to check on the first compile

I could not run `ssc_build` while writing this, so treat the following as
the list of items to verify rather than as verified behaviour:

- **Nested `if` in the static characteristic.** If the compiler objects,
  flatten it to `if (G > Vg_on) && (v > V0_T) … elseif G > Vg_on … else …`.
- **Event variable assigned in two `when` clauses** (`t_ev`, armed at
  turn-on and re-armed at the delayed evaluation). If this is rejected,
  split it into two event variables and compare their difference.
- **Thermal sign.** See point 4 above.
- **`t_meas` vs switching frequency.** It must be much shorter than the
  shortest on-time, otherwise the delayed turn-on evaluation lands after the
  device has already turned off and `Eon` will be sampled at the wrong
  current. Default 500 ns is safe down to a few microseconds of on-time.
- **Extrapolation.** The tables extrapolate linearly. Beyond the last
  current point this stays reasonable; below zero the positive clip
  (`i_pos`) keeps the lookup at the first row.

## 8. Limitations worth stating in a report

- The tail is a single exponential. The real decay is closer to a diffusion
  profile and shows two slopes, especially on field-stop parts. A second
  exponential can be added by duplicating `I_tl0`/`t_off`/`τ_tail`.
- The tail amplitude is a fixed fraction of `Ic`. In reality it depends on
  the stored charge, hence on the on-time for short pulses. For PWM at
  constant frequency this is a good approximation; for very short pulses it
  over-estimates the tail.
- Switching energy is assumed independent of the previous state (no
  short-pulse effects, no dynamic avalanche).
- Soft switching is not represented: if the device turns on with `v ≈ 0` the
  model correctly gives near-zero `Eon` through the voltage scaling, but
  ZVS/ZCS turn-off is not treated specially.
