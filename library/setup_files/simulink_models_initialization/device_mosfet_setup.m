
%% example 
% used_device = 'danfoss_SKM1700MB20R4S2I4';
% mosfet.dab = device_mosfet_setup(used_device,glb_time.fPWM_DAB, hwdata.dab.udc1_nom);


function dev = device_mosfet_setup(device, fpwm, udc)

run(device);
dev = device_mosfet_setting(device_name, device_type, Vth, Rds_on, Vdon_diode, Rdon_diode, Eon, Eoff, Err, ...
                    Voff_sw_losses, Ion_sw_losses, JunctionTermalMass, Rtim, Rth_mosfet_JC, Rth_mosfet_CH, Rth_mosfet_JH, ...
                    Lstray_module, Lstray_d, RLd, Lstray_s, RLs, Ciss, Coss, Crss, Cgs, Cgd, Cds,Rgate_internal, Irr, ...
                    Csnubber, Rsnubber, fpwm, udc);
end