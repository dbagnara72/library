function hwdata = global_hardware_setup(application_voltage,fpwm_afe, fpwm_inv, fpwm_dab, fpwm_cllc, fres)

    %% dclink for three level is splitted into two parts CFi1, CFi2
    % for DAB is used CFi1_dc1, CFi2_dc1, CFi1_dc2, and CFi2_dc2
    
    % Arguments : inverter(name, us, is, freq, udc, fpwm, LFi);
    % Arguments : afe(name, us, is, freq, udc, fpwm, CFi, RCFi, CFi1, RCFi1, CFi2, RCFi2, LFu, RLFu, LFu_cm, RLFu_cm, CFu, RCFu, Rbrake)
    % Arguments : dab(name, udc1, udc2, uac1, uac2, idc1, idc2, fpwm, fres, Cs1, Ls1,
    % n12, Lm, Lsigma1, Lsigma2, Cs2, Ls2, Cdc_dc1, Cdc1_dc1, Cdc2_dc1, 
    % Cdc_dc2, Cdc1_dc2, Cdc2_dc2);

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
    afe690V_250kW = afe('afe690V_250kW', uafe_nom, iafe_nom, iafe_freq, udc, fpwm_afe, CFi, ...
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
    afe400V_250kW = afe('afe400V_250kW', uafe_nom, iafe_nom, iafe_freq, udc, fpwm_afe, CFi, ...
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
    afe480V_250kW = afe('afe480V_250kW', uafe_nom, iafe_nom, iafe_freq, udc, fpwm_afe, CFi, ...
        RCFi, CFi1, RCFi1, CFi2, RCFi2, LFu, RLFu, LFu_cm, RLFu_cm, CFu, RCFu, Rbrake);

    %% INVERTER 690V - 250kW
    u_inv_nom = 550;
    i_inv_nom = 370;
    i_inv_freq = 15.6;
    udc = 1070;
    LFi = 230e-6; LFi_cm = 230e-6;
    RLFi = 157*0.05*LFi; RLFi_cm = 157*0.05*LFi_cm;
    inv690V_250kW = inverter('inv690V_250kW', u_inv_nom, i_inv_nom, i_inv_freq, udc, fpwm_inv, LFi, RLFi, LFi_cm, RLFi_cm);

    %% INVERTER 400V - 250kW
    u_inv_nom = 400;
    i_inv_nom = 470;
    i_inv_freq = 15.6;
    udc = 660;
    LFi = 160e-6; LFi_cm = 160e-6;
    RLFi = 157*0.05*LFi; RLFi_cm = 157*0.05*LFi_cm;
    inv400V_250kW = inverter('inv400V_250kW', u_inv_nom, i_inv_nom, i_inv_freq, udc, fpwm_inv, LFi, RLFi, LFi_cm, RLFi_cm);

    %% INVERTER 480V - 250kW
    u_inv_nom = 400;
    i_inv_nom = 470;
    i_inv_freq = 15.6;
    udc = 750;
    LFi = 160e-6; LFi_cm = 160e-6;
    RLFi = 157*0.05*LFi; RLFi_cm = 157*0.05*LFi_cm;
    inv480V_250kW = inverter('inv480V_250kW', u_inv_nom, i_inv_nom, i_inv_freq, udc, fpwm_inv, LFi, RLFi, LFi_cm, RLFi_cm);


    %% CLLC 800V - 250kW
    udc1 = 800;
    udc2 = 800;
    uac1 = 800;
    uac2 = 800;
    idc1 = 350;
    idc2 = 350;
    cllc_tank = cllc_tank_design(fres,udc1,250e3);
    Ls1 = 0.5 * cllc_tank.Ls;
    Cs1 = 2.0 * cllc_tank.Cs;
    Lm = 1e-3;
    n1 = 6;
    n2 = 6;
    n12 = n1/n2;
    Ld1 = Ls1;
    Ld2 = Ls1/n12^2;
    Ls2 = Ls1/n12^2;
    Cs2 = Cs1*n12^2;

    Rfe = 1e3;
    Rs1 = 1e-3;
    Rs2 = 1e-3;

    core_length = 1;
    core_mur = 75;

    Cdc_dc1 = 3.6e-3; 
    Cdc1_dc1 = 2*Cdc_dc1; Cdc2_dc1 = 2*Cdc_dc1;
    Cdc_dc2 = 3.6e-3; 
    Cdc1_dc2 = 2*Cdc_dc2; Cdc2_dc2 = 2*Cdc_dc2;
    
    RCdc_dc1 = 1e-3; 
    RCdc1_dc1 = RCdc_dc1/2; RCdc2_dc1 = RCdc_dc1/2;
    RCdc_dc2 = 1e-3; 
    RCdc1_dc2 = Cdc_dc2/2; RCdc2_dc2 = RCdc_dc2/2;   
    
    Ldc_dc1 = 250e-6; 
    RLdc_dc1 = 157*0.05*Ldc_dc1; 
    Ldc_dc2 = 250e-6; 
    RLdc_dc2 = 157*0.05*Ldc_dc2; 
    margin_factor = 1.25;
    idc_FS = max(idc1,idc2) * margin_factor;
    udc_FS = max(udc1,udc2) * margin_factor;

    cllc800V_250kW = cllc('CLLC_800V', udc1, udc2, uac1, uac2, idc1, idc2, fpwm_cllc, fres, Cs1, Ls1, ...
            n1, n2, Lm, Rfe, Ld1, Ld2, Rs1, Rs2, Cs2, Ls2, core_length, core_mur, Cdc_dc1, Cdc1_dc1, Cdc2_dc1, Cdc_dc2, ...
            Cdc1_dc2, Cdc2_dc2, RCdc_dc1, RCdc1_dc1, RCdc2_dc1, RCdc_dc2, RCdc1_dc2, RCdc2_dc2, ...
            Ldc_dc1, Ldc_dc2, RLdc_dc1, RLdc_dc2, idc_FS, udc_FS);
   
    
    %% CLLC 1200V - 250kW
    udc1 = 1200;
    udc2 = 1200;
    uac1 = 1000;
    uac2 = 1000;
    idc1 = 250;
    idc2 = 250;
    cllc_tank = cllc_tank_design(fres,udc1,250e3);
    Ls1 = 0.5 * cllc_tank.Ls;
    Cs1 = 2.0 * cllc_tank.Cs;

    Lm = 1e-3;
    n1 = 6;
    n2 = 6;
    n12 = n1/n2;
    Ld1 = Ls1;
    Ld2 = Ls1/n12^2;
    Ls2 = Ls1/n12^2;
    Cs2 = Cs1*n12^2;

    Rfe = 1e3;
    Rs1 = 1e-3;
    Rs2 = 1e-3;
    core_length = 1;
    core_mur = 75;
    Cdc_dc1 = 3.6e-3; 
    Cdc1_dc1 = 2*Cdc_dc1; Cdc2_dc1 = 2*Cdc_dc1;
    Cdc_dc2 = 3.6e-3; 
    Cdc1_dc2 = 2*Cdc_dc2; Cdc2_dc2 = 2*Cdc_dc2;
   
    RCdc_dc1 = 1e-3; 
    RCdc1_dc1 = RCdc_dc1/2; RCdc2_dc1 = RCdc_dc1/2;
    RCdc_dc2 = 1e-3; 
    RCdc1_dc2 = Cdc_dc2/2; RCdc2_dc2 = RCdc_dc2/2;   
    
    Ldc_dc1 = 250e-6; 
    RLdc_dc1 = 157*0.05*Ldc_dc1; 
    Ldc_dc2 = 250e-6; 
    RLdc_dc2 = 157*0.05*Ldc_dc2; 
    margin_factor = 1.25;
    idc_FS = max(idc1,idc2) * margin_factor;
    udc_FS = max(udc1,udc2) * margin_factor;

    cllc1200V_250kW = cllc('CLLC_1200V', udc1, udc2, uac1, uac2, idc1, idc2, fpwm_cllc, fres, Cs1, Ls1, ...
            n1, n2, Lm, Rfe, Ld1, Ld2, Rs1, Rs2, Cs2, Ls2, core_length, core_mur, Cdc_dc1, Cdc1_dc1, Cdc2_dc1, Cdc_dc2, ...
            Cdc1_dc2, Cdc2_dc2, RCdc_dc1, RCdc1_dc1, RCdc2_dc1, RCdc_dc2, RCdc1_dc2, RCdc2_dc2, ...
            Ldc_dc1, Ldc_dc2, RLdc_dc1, RLdc_dc2, idc_FS, udc_FS);   
    
    
    %% DAB 800V - 250kW
    udc1 = 800;
    udc2 = 800;
    uac1 = 800;
    uac2 = 800;
    idc1 = 350;
    idc2 = 350;
    dab_tank = dab_tank_design(fpwm_dab, fres, udc1, 250e3);
    Ls1 = 0.5 * dab_tank.Ls;
    Cs1 = 2.0 * dab_tank.Cs;
    Lm = 1e-3;
    n1 = 6;
    n2 = 6;
    n12 = n1/n2;
    Ld1 = Ls1;
    Ld2 = Ls1/n12^2;
    Ls2 = Ls1/n12^2;
    Cs2 = Cs1*n12^2;

    Rfe = 1e3;
    Rs1 = 1e-3;
    Rs2 = 1e-3;

    core_length = 1;
    core_mur = 75;

    Cdc_dc1 = 3.6e-3; 
    Cdc1_dc1 = 2*Cdc_dc1; Cdc2_dc1 = 2*Cdc_dc1;
    Cdc_dc2 = 3.6e-3; 
    Cdc1_dc2 = 2*Cdc_dc2; Cdc2_dc2 = 2*Cdc_dc2;
    
    RCdc_dc1 = 1e-3; 
    RCdc1_dc1 = RCdc_dc1/2; RCdc2_dc1 = RCdc_dc1/2;
    RCdc_dc2 = 1e-3; 
    RCdc1_dc2 = Cdc_dc2/2; RCdc2_dc2 = RCdc_dc2/2;   
    
    Ldc_dc1 = 250e-6; 
    RLdc_dc1 = 157*0.05*Ldc_dc1; 
    Ldc_dc2 = 250e-6; 
    RLdc_dc2 = 157*0.05*Ldc_dc2; 
    margin_factor = 1.25;
    idc_FS = max(idc1,idc2) * margin_factor;
    udc_FS = max(udc1,udc2) * margin_factor;

    dab800V_250kW = dab('DAB_800V', udc1, udc2, uac1, uac2, idc1, idc2, fpwm_dab, fres, Cs1, Ls1, ...
            n1, n2, Lm, Rfe, Ld1, Ld2, Rs1, Rs2, Cs2, Ls2, core_length, core_mur, Cdc_dc1, Cdc1_dc1, Cdc2_dc1, Cdc_dc2, ...
            Cdc1_dc2, Cdc2_dc2, RCdc_dc1, RCdc1_dc1, RCdc2_dc1, RCdc_dc2, RCdc1_dc2, RCdc2_dc2, ...
            Ldc_dc1, Ldc_dc2, RLdc_dc1, RLdc_dc2, idc_FS, udc_FS);

    
    %% DAB 1200V - 250kW
    udc1 = 1200;
    udc2 = 1200;
    uac1 = 1000;
    uac2 = 1000;
    idc1 = 250;
    idc2 = 250;
    dab_tank = dab_tank_design(fpwm_dab, fres, udc1, 250e3);
    Ls1 = 0.5 * dab_tank.Ls;
    Cs1 = 2.0 * dab_tank.Cs;

    Lm = 1e-3;
    n1 = 6;
    n2 = 6;
    n12 = n1/n2;
    Ld1 = Ls1;
    Ld2 = Ld1/n12^2;
    Ls2 = Ls1/n12^2;
    Cs2 = Cs1*n12^2;

    Rfe = 1e3;
    Rs1 = 1e-3;
    Rs2 = 1e-3;
    core_length = 1;
    core_mur = 75;
    Cdc_dc1 = 3.6e-3; 
    Cdc1_dc1 = 2*Cdc_dc1; Cdc2_dc1 = 2*Cdc_dc1;
    Cdc_dc2 = 3.6e-3; 
    Cdc1_dc2 = 2*Cdc_dc2; Cdc2_dc2 = 2*Cdc_dc2;
   
    RCdc_dc1 = 1e-3; 
    RCdc1_dc1 = RCdc_dc1/2; RCdc2_dc1 = RCdc_dc1/2;
    RCdc_dc2 = 1e-3; 
    RCdc1_dc2 = Cdc_dc2/2; RCdc2_dc2 = RCdc_dc2/2;   
    
    Ldc_dc1 = 250e-6; 
    RLdc_dc1 = 157*0.05*Ldc_dc1; 
    Ldc_dc2 = 250e-6; 
    RLdc_dc2 = 157*0.05*Ldc_dc2; 
    margin_factor = 1.25;
    idc_FS = max(idc1,idc2) * margin_factor;
    udc_FS = max(udc1,udc2) * margin_factor;

    dab1200V_250kW = dab('DAB_1200V', udc1, udc2, uac1, uac2, idc1, idc2, fpwm_dab, fres, Cs1, Ls1, ...
            n1, n2, Lm, Rfe, Ld1, Ld2, Rs1, Rs2, Cs2, Ls2, core_length, core_mur, Cdc_dc1, Cdc1_dc1, Cdc2_dc1, Cdc_dc2, ...
            Cdc1_dc2, Cdc2_dc2, RCdc_dc1, RCdc1_dc1, RCdc2_dc1, RCdc_dc2, RCdc1_dc2, RCdc2_dc2, ...
            Ldc_dc1, Ldc_dc2, RLdc_dc1, RLdc_dc2, idc_FS, udc_FS);   

    %% setup outputs
    if application_voltage == 690
        hwdata.afe = afe690V_250kW;
        hwdata.inv = inv690V_250kW;
        hwdata.dab = dab1200V_250kW;
        hwdata.cllc = cllc1200V_250kW;
        afe690V_250kW.displayInfo();
        inv690V_250kW.displayInfo();
        dab1200V_250kW.displayInfo();
        cllc1200V_250kW.displayInfo();
    elseif application_voltage == 480
        hwdata.afe = afe480V_250kW;
        hwdata.inv = inv480V_250kW;
        hwdata.dab = dab800V_250kW;
        hwdata.cllc = cllc800V_250kW;
        afe480V_250kW.displayInfo();
        inv480V_250kW.displayInfo();
        dab800V_250kW.displayInfo();
        dab800V_250kW.displayInfo();
    else
        hwdata.afe = afe400V_250kW;
        hwdata.inv = inv400V_250kW;
        hwdata.dab = dab800V_250kW;
        hwdata.cllc = cllc800V_250kW;
        afe400V_250kW.displayInfo();
        inv400V_250kW.displayInfo();
        dab800V_250kW.displayInfo();
        dab800V_250kW.displayInfo();
    end

end
