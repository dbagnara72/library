
%% 5SNA1000G650300 (IGBT) data at 125°C junction
device_name = 'abb_5SNA1000G650300';
device_type = 'Si-IGBT';

Vth = 5.5;                                              % [V]
Rce_on = 2.00e-3;                                       % [Ohm]
Vce_sat = 4.15;                                         % [V]
Vdon_diode = 3.45;                                      % [V]
Rdon_diode = 1.00e-3;                                   % [Ohm]
Eon = 5250e-3;                                          % [J] @ Tj = 125°C
Eoff = 5400e-3;                                         % [J] @ Tj = 125°C
Erec = 4150e-3;                                         % [J] @ Tj = 125°C
Voff_sw_losses = 3600;                                  % [V]
Ion_sw_losses = 1000;                                   % [A]
JunctionTermalMass = 1.0;                               % [J/K]
Rtim = 4.0/1000;                                        % [K/W]
Rth_switch_JC = 9.80/1000;                              % [K/W]
Rth_switch_CH = 8.00/1000;                              % [K/W]
Rth_switch_JH = Rtim + Rth_switch_JC + Rth_switch_CH;   % [K/W]
Rth_diode_JC = 16.0/1000;                               % [K/W]
Rth_diode_CH = 11.0/1000;                               % [K/W]
Rth_diode_JH = Rtim + Rth_diode_JC + Rth_diode_CH;      % [K/W]
Lstray_module = 18e-9;                                  % [H]
Irr = 2230;                                             % [A]
Cies = 101e-9;                                          % [F]
Cres = 30e-9;                                           % [F]
Rgate_internal = 0.74;                                  % [F]
td_on = 500e-9;                                         % [s]
trise = 160e-9;                                         % [s]
td_off = 5650e-9;                                       % [s]
tfall = 460e-9;                                         % [s]
Csnubber = 12e-12;                                      % [F]
Rsnubber = 2200;                                        % [Ohm]
% ------------------------------------------------------------