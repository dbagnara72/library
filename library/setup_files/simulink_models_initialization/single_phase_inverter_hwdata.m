function single_phase_inverter = single_phase_inverter_hwdata(name, pwr_nom, fpwm)

    %% dclink for three level is splitted into two parts CFi1, CFi2
  
  
    %% Single Phase Inverter
    u_nom = 690;
    i_nom = 270;
    f_nom = 50;
    udc_nom = 1070;
    CFi = 1500e-6 * 4; CFi1 = 2*CFi; CFi2 = 2*CFi;
    RCFi = 1e-3; RCFi1 = RCFi/2; RCFi2 = RCFi/2;
    LFu = 500e-6; LFu_cm = 500e-6;
    RLFu = 157*0.05*LFu; RLFu_cm = 157*0.05*LFu_cm;
    CFu = 200e-6;
    RCFu = 50e-3;
    Rbrake = 4;

    single_phase_inverter = hw_single_phase_inverter_setup(name, pwr_nom, u_nom, i_nom, f_nom, udc_nom, fpwm, CFi, ...
        RCFi, CFi1, RCFi1, CFi2, RCFi2, LFu, RLFu, LFu_cm, RLFu_cm, CFu, RCFu, Rbrake);

end
