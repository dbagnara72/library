function three_phase_afe = three_phase_afe_hwdata(application_voltage, pwr_nom, fpwm_afe)

    %% dclink for three level is splitted into two parts CFi1, CFi2
    % for DC/DC is used CFi1_dc1, CFi2_dc1, CFi1_dc2, and CFi2_dc2
    
  
    %% AFE 690V - 250kW
    uafe_nom = 690;
    iafe_nom = 270;
    iafe_freq = 50;
    udc = 1070;
    CFi = 7.2e-3; CFi1 = 2*CFi; CFi2 = 2*CFi;
    RCFi = 1e-3; RCFi1 = RCFi/2; RCFi2 = RCFi/2;
    LFu = 500e-6; LFu_cm = 500e-6;
    RLFu = 157*0.05*LFu; RLFu_cm = 157*0.05*LFu_cm;
    CFu = 200e-6;
    RCFu = 50e-3;
    Rbrake = 4;

    afe690V_250kW = afe_three_phase('afe690V_250kW', pwr_nom, uafe_nom, iafe_nom, iafe_freq, udc, fpwm_afe, CFi, ...
        RCFi, CFi1, RCFi1, CFi2, RCFi2, LFu, RLFu, LFu_cm, RLFu_cm, CFu, RCFu, Rbrake);

    %% AFE 400V - 250kW
    uafe_nom = 400;
    iafe_nom = 360;
    iafe_freq = 50;
    udc = 660;
    CFi = 7.2e-3; CFi1 = 2*CFi; CFi2 = 2*CFi;
    RCFi = 1e-3; RCFi1 = RCFi/2; RCFi2 = RCFi/2;
    LFu = 330e-6; LFu_cm = 330e-6;
    RLFu = 157*0.05*LFu; RLFu_cm = 157*0.05*LFu_cm;
    CFu = 360e-6;
    RCFu = 50e-3;
    Rbrake = 2.5;

    afe400V_250kW = afe_three_phase('afe400V_250kW', pwr_nom, uafe_nom, iafe_nom, iafe_freq, udc, fpwm_afe, CFi, ...
        RCFi, CFi1, RCFi1, CFi2, RCFi2, LFu, RLFu, LFu_cm, RLFu_cm, CFu, RCFu, Rbrake);

    %% AFE 480V - 250kW
    uafe_nom = 480;
    iafe_nom = 360;
    iafe_freq = 60;
    udc = 750;
    CFi = 7.2e-3; CFi1 = 2*CFi; CFi2 = 2*CFi;
    RCFi = 1e-3; RCFi1 = RCFi/2; RCFi2 = RCFi/2;
    LFu = 330e-6; LFu_cm = 330e-6;
    RLFu = 157*0.05*LFu; RLFu_cm = 157*0.05*LFu_cm;
    RCFu = 50e-3;
    CFu = 360e-6;
    Rbrake = 2.5;

    afe480V_250kW = afe_three_phase('afe480V_250kW', pwr_nom, uafe_nom, iafe_nom, iafe_freq, udc, fpwm_afe, CFi, ...
        RCFi, CFi1, RCFi1, CFi2, RCFi2, LFu, RLFu, LFu_cm, RLFu_cm, CFu, RCFu, Rbrake);

    %% setup outputs
    if application_voltage == 690
        three_phase_afe = afe690V_250kW;
        afe690V_250kW.displayInfo();
    elseif application_voltage == 480
        three_phase_afe = afe480V_250kW;
        afe480V_250kW.displayInfo();
    else
        three_phase_afe = afe400V_250kW;
        afe400V_250kW.displayInfo();
    end

end
