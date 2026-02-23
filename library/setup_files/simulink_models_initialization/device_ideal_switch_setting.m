function ideal_switch = device_ideal_switch_setting(device, fpwm, udc)
run(device);
    ideal_switch.device_name = device_name;
    ideal_switch.Vth = Vth;                                  % [V]
    ideal_switch.Rds_on = Rds_on;                            % [Ohm]
    ideal_switch.Vdon_diode = Vdon_diode;                    % [V]
    ideal_switch.Vgamma = Vgamma;                            % [V]
    ideal_switch.Rdon_diode = Rdon_diode;                    % [Ohm]
    ideal_switch.Csnubber = Csnubber;                        % [F]
    ideal_switch.Rsnubber = Rsnubber;                        % [Ohm]
    ideal_switch.Irr = Irr;                                  % [A]
    ideal_switch.Lstray_module = Lstray_module;              % [H]
    ideal_switch.Csnubber_zvs = (ideal_switch.Irr)^2*ideal_switch.Lstray_module/(udc)^2;
    ideal_switch.Rsnubber_zvs = 1/(ideal_switch.Csnubber_zvs*fpwm)/5;
end