

%% class definition
classdef device_mosfet_setting
    properties
        name                 string
        type                 string
        Vth                  % [V]
        Rds_on               % [Ohm]
        g_fs                 % [A/V]
        Vdon_diode           % [V]
        Vgamma               % [V]
        Rdon_diode           % [Ohm]
        Eon                  % [J] @ Tj = 125°C
        Eoff                 % [J] @ Tj = 125°C
        Err                  % [J] @ Tj = 125°C
        Voff_sw_losses       % [V]
        Ion_sw_losses        % [A]
        JunctionTermalMass   % [J/K]
        Rtim                 % [K/W]
        Rth_mosfet_JC        % [K/W]
        Rth_mosfet_CH        % [K/W]
        Rth_mosfet_JH        % [K/W]
        Lstray_module        % [H]
        Lstray_d             % [H]
        RLd                  % [Ohm]
        Lstray_s             % [H]
        RLs                  % [Ohm]
        Ciss                 % [F]
        Coss                 % [F]
        Crss                 % [F]
        Cgs                  % [F]
        Cgd                  % [F]
        Cds                  % [F]
        Rgate_internal       % [Ohm]
        Irr                  % [A]
        Csnubber             % [F]
        Rsnubber             % [Ohm]
        Csnubber_zvs         % [F]
        Rsnubber_zvs         % [Ohm]       
    end
        methods
            function obj = device_mosfet_setting(device_name, device_type, Vth, Rds_on, Vdon_diode, Rdon_diode, Eon, Eoff, Err, ...
                    Voff_sw_losses, Ion_sw_losses, JunctionTermalMass, Rtim, Rth_mosfet_JC, Rth_mosfet_CH, Rth_mosfet_JH, ...
                    Lstray_module, Lstray_d, RLd, Lstray_s, RLs, Ciss, Coss, Crss, Cgs, Cgd, Cds,Rgate_internal, Irr, ...
                    Csnubber, Rsnubber, fpwm, udc)
                if nargin > 0
                    obj.name = device_name;
                    obj.type = device_type;
                    obj.Vth = Vth;
                    obj.Rds_on = Rds_on;
                    obj.Vdon_diode = Vdon_diode;
                    obj.Rdon_diode = Rdon_diode;
                    obj.Eon = Eon;
                    obj.Eoff = Eoff;
                    obj.Err = Err;
                    obj.Voff_sw_losses = Voff_sw_losses;
                    obj.Ion_sw_losses = Ion_sw_losses;
                    obj.JunctionTermalMass = JunctionTermalMass;
                    obj.Rtim = Rtim;
                    obj.Rth_mosfet_JC = Rth_mosfet_JC;
                    obj.Rth_mosfet_CH = Rth_mosfet_CH;
                    obj.Rth_mosfet_JH = Rth_mosfet_JH;
                    obj.Lstray_module = Lstray_module;
                    obj.Lstray_d = Lstray_d;
                    obj.RLd = RLd;
                    obj.Lstray_s = Lstray_s;
                    obj.RLs = RLs;
                    obj.Ciss = Ciss;
                    obj.Coss = Coss;
                    obj.Crss = Crss;
                    obj.Cgs = Cgs;
                    obj.Cgd = Cgd;
                    obj.Cds = Cds;
                    obj.Rgate_internal = Rgate_internal;
                    obj.Irr = Irr;
                    obj.Csnubber = Csnubber;
                    obj.Rsnubber = Rsnubber;
                    obj.Csnubber_zvs = (obj.Irr)^2*obj.Lstray_module/(udc)^2;
                    obj.Rsnubber_zvs = 1/(obj.Csnubber_zvs*fpwm)/5;
                end
            end
        end
end
