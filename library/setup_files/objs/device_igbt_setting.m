

%% class definition
classdef device_igbt_setting
    properties
        name                    string
        type                    string
        
        Vth                     % [V]
        Rce_on                  % [Ohm]
        Vce_sat                 % [V]
        Vdon_diode              % [V]
        Rdon_diode              % [Ohm]
        Eon                     % [J] @ Tj = 125°C
        Eoff                    % [J] @ Tj = 125°C
        Erec                    % [J] @ Tj = 125°C
        Voff_sw_losses          % [V]
        Ion_sw_losses           % [A]
        JunctionTermalMass      % [J/K]
        Rtim                    % [K/W]
        Rth_switch_JC           % [K/W]
        Rth_switch_CH           % [K/W]
        Rth_switch_JH           % [K/W]
        Rth_diode_JC            % [K/W]
        Rth_diode_CH            % [K/W]
        Rth_diode_JH            % [K/W]
        Lstray_module           % [H]
        Irr                     % [A]
        Cies                    % [F]
        Cres                    % [F]
        Rgate_internal          % [F]
        td_on                   % [s]
        trise                   % [s]
        td_off                  % [s]
        tfall                   % [s]
        Csnubber                % [F]
        Rsnubber                % [Ohm]   
        Csnubber_zvs            % [F]
        Rsnubber_zvs            % [Ohm]   
    end
        methods
            function obj = device_igbt_setting(device_name, device_type, Vth, Rce_on, Vce_sat, Vdon_diode, ...
                    Rdon_diode, Eon, Eoff, Erec, Voff_sw_losses, Ion_sw_losses, JunctionTermalMass, Rtim, ...
                    Rth_switch_JC, Rth_switch_CH, Rth_switch_JH, Rth_diode_JC, Rth_diode_CH, Rth_diode_JH, ...
                    Lstray_module, Cies, Cres, td_on, trise, td_off, tfall,Rgate_internal, Irr, ...
                    Csnubber, Rsnubber, fpwm, udc)
                if nargin > 0
                    obj.name = device_name;
                    obj.type = device_type;
                    
                    obj.Vth = Vth;
                    obj.Rce_on = Rce_on;
                    obj.Vce_sat = Vce_sat;
                    obj.Vdon_diode = Vdon_diode;
                    obj.Rdon_diode = Rdon_diode;
                    obj.Eon = Eon; 
                    obj.Eoff = Eoff;
                    obj.Erec = Erec;
                    obj.Voff_sw_losses = Voff_sw_losses;
                    obj.Ion_sw_losses = Ion_sw_losses;
                    obj.JunctionTermalMass = JunctionTermalMass;
                    obj.Rtim = Rtim;
                    obj.Rth_switch_JC = Rth_switch_JC;
                    obj.Rth_switch_CH = Rth_switch_CH;
                    obj.Rth_switch_JH = Rth_switch_JH;
                    obj.Rth_diode_JC = Rth_diode_JC;
                    obj.Rth_diode_CH = Rth_diode_CH;
                    obj.Rth_diode_JH = Rth_diode_JH;
                    obj.Lstray_module = Lstray_module;
                    obj.Irr = Irr;
                    obj.Cies = Cies;
                    obj.Cres = Cres;
                    obj.Rgate_internal = Rgate_internal;
                    obj.td_on = td_on;
                    obj.trise = trise;
                    obj.td_off = td_off;
                    obj.tfall = tfall;
                    obj.Csnubber = Csnubber;
                    obj.Rsnubber = Rsnubber;
                    obj.Csnubber_zvs = (obj.Irr)^2*obj.Lstray_module/(udc)^2;
                    obj.Rsnubber_zvs = 1/(obj.Csnubber_zvs*fpwm)/5;
                end
            end
        end
end
