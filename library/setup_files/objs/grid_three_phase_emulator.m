classdef grid_three_phase_emulator
    properties
        name                string
        pwr_nom             double {mustBePositive} % Nominal power [W]
        application_voltage double {mustBePositive} % application voltage: 690V, 480V or 400V [V]
        us_primary_nom      double {mustBePositive} % Transformer nominal primary side voltage [V]
        is_primary_nom      double {mustBePositive} % Transformer nominal primary side current [A]
        us_secondary_nom    double {mustBePositive} % Transformer nominal secondary side voltage [V]
        is_secondary_nom    double {mustBePositive} % Transformer nominal secondary side current [A]
        fgrid_nom           double {mustBePositive} % Nominal frequency [Hz]
        omega_grid_nom      double {mustBePositive} % Nominal pulsation [rad/s]
        ucc                 double {mustBePositive} % Transformer short circuit voltage [%]
        i1m                 double {mustBePositive} % Transformer primary side magnetization current [A]
        n12                 double {mustBePositive} % Transformer U1/U2 []
        Rd1_trafo           double {mustBePositive} % Transformer primary side winding resistance [Ohm]
        Ld1_trafo           double {mustBePositive} % Normalization Voltage Factor [V]
        Lm1_trafo           double {mustBePositive} % Normalization Voltage Factor [V]
        Rd2_trafo           double {mustBePositive} % Normalization Voltage Factor [V]
        Ld2_trafo           double {mustBePositive} % Normalization Voltage Factor [V]
        Lm2_trafo           double {mustBePositive} % Normalization Voltage Factor [V]
        p_iron
        Rfe1_trafo
        psi_trafo
        udc_nom             double {mustBePositive} % Nominal DC-link voltage [V]

        i1bez               double {mustBePositive} % Normalization Current Factor [A]
        u1bez               double {mustBePositive} % Normalization Voltage Factor [V]
        i2bez               double {mustBePositive} % Normalization Current Factor [A]
        u2bez               double {mustBePositive} % Normalization Voltage Factor [V]
        
        up_xi_pu            double {mustBePositive} % Normalization Voltage Factor [V]
        up_eta_pu           double {mustBePositive} % Normalization Voltage Factor [V]
        un_xi_pu            double {mustBePositive} % Normalization Voltage Factor [V]
        un_eta_pu           double {mustBePositive} % Normalization Voltage Factor [V]

        ugrid_factor
        kp_vgrid
        ki_vgrid
        k_ff

        igrid_bez
        ugrid_bez

        Vemu_ref
        Vemu_ref_norm
    end
    
    methods
        function obj = grid_three_phase_emulator(name, pwr_nom, application_voltage, us1, is1, us2, is2, fgrid, ucc, i1m, p_iron)
            if nargin > 0
                obj.name = name;
                obj.application_voltage = application_voltage;
                obj.pwr_nom = pwr_nom;
                obj.us_primary_nom = us1;
                obj.is_primary_nom = is1;
                obj.us_secondary_nom = us2;
                obj.is_secondary_nom = is2;
                obj.fgrid_nom = fgrid;
                obj.ucc = ucc;
                obj.i1m = i1m;
                obj.n12 = ug1/ug2;

                obj.omega_grid_nom = freq * 2*pi;
                
                obj.Ld1_trafo = 0.5 * (us1*ucc/100/sqrt(3)/is1/obj.omega_grid_nom);
                obj.Rd1_trafo = 0.5 * (0.05 * pwr_nom / 3 / is1^2); 
                obj.Lm1_trafo = us1/sqrt(3)/i1m/obj.omega_grid_nom;
                
                obj.Ld2_trafo = obj.Ld1_trafo / (obj.n12)^2;
                obj.Rd2_trafo = obj.Rd1_trafo / (obj.n12)^2;
                obj.Lm2_trafo = obj.Lm1_trafo / (obj.n12)^2;
                
                obj.p_iron = p_iron;
                obj.Rfe1_trafo = (us1/sqrt(3))^2/(p_iron/3);
                obj.psi_trafo = obj.Lm1_trafo*obj.i1m*sqrt(2);

                obj.udc_nom = obj.us_secondary_nom * sqrt(2) * 1.1;
                obj.u1bez =  obj.us_primary_nom * sqrt(2/3);
                obj.i1bez =  obj.is_primary_nom * sqrt(2);
                obj.u1bez =  obj.us_secondary_nom * sqrt(2/3);
                obj.i1bez =  obj.is_secondary_nom * sqrt(2);

                obj.kp_vgrid = 10;
                obj.ki_vgrid = 45;
                obj.k_ff = 1;
                obj.ugrid_factor = 1;

                %% voltage reference grid emulator
                if (application_voltage == 690)
                    obj.igrid_bez = 270*sqrt(2);
                    obj.ugrid_bez = 690*sqrt(2/3);
                elseif (application_voltage == 480)
                    obj.igrid_bez = 360*sqrt(2);
                    obj.ugrid_bez = 480*sqrt(2/3);
                else
                    obj.igrid_bez = 360*sqrt(2);
                    obj.ugrid_bez = 400*sqrt(2/3);
                end
                
                if (application_voltage == 690)
                    obj.Vemu_ref = 690/sqrt(3) * obj.ugrid_factor;
                    obj.Vemu_ref_norm = Vemu_ref * sqrt(2) / obj.ugrid_bez;
                elseif (application_voltage == 480)
                    obj.Vemu_ref = 480/sqrt(3) * obj.ugrid_factor;
                    obj.Vemu_ref_norm = Vemu_ref * sqrt(2) / obj.ugrid_bez;
                else
                    obj.Vemu_ref = 400/sqrt(3) * obj.ugrid_factor;
                    obj.Vemu_ref_norm = Vemu_ref * sqrt(2) / obj.ugrid_bez;
                end
                

            end
        end
        
        function displayInfo(obj)
            fprintf('Device AFE_THREE_PHASE: %s\n', obj.name);
            fprintf('Nominal Voltage: %d V | Nominal Current: %d A\n', obj.us_nom, obj.is_nom);
            fprintf('Current Normalization Data: %.2f A\n', obj.ibez);
            fprintf('Voltage Normalization Data: %.2f V\n', obj.ubez);
            fprintf('---------------------------\n');
        end
    end
end


function grid_emu_data = grid_emulator(nominal_power, application_voltage, vp_xi_pu, vn_xi_pu, vn_eta_pu)

    grid_emu_data.vp_xi_pu = vp_xi_pu;
    grid_emu_data.vn_xi_pu = vn_xi_pu;
    grid_emu_data.vp_eta_pu = 0;
    grid_emu_data.vn_eta_pu = vn_eta_pu;
    
    application690 = 690;
    application480 = 480;
    grid_emu_data.application_voltage = application_voltage;
    %% grid emulator output transformer
    grid_emu_data.Ptrafo = nominal_power;
    grid_emu_data.I0 = 5; % no load current
    grid_emu_data.Vcc_perc = 6.6; %cc voltage percente
    
    
    if (application690 == application_voltage)
        Vline1 = 690; % primary voltage
        Vline2 = 690; % secondary voltage
        f_grid = 50;
        Vdclink_nom = 1070;
    elseif (application480 == application_voltage)
        Vline1 = 480; % primary voltage
        Vline2 = 480; % secondary voltage
        f_grid = 60;
        Vdclink_nom = 750;
    else
        Vline1 = 400; % primary voltage
        Vline2 = 400; % secondary voltage
        f_grid = 50;
        Vdclink_nom = 660;
    end
    
    grid_emu_data.nominal_frequency = f_grid;
    grid_emu_data.nominal_voltage = Vline2;

    grid_emu_data.Vphase1 = Vline1/sqrt(3);
    grid_emu_data.Vphase2 = Vline2/sqrt(3);
    
    grid_emu_data.w_grid = f_grid*2*pi;

    grid_emu_data.omega_grid_emulator_nom = grid_emu_data.w_grid;
    grid_emu_data.omega_grid_nom = grid_emu_data.w_grid;
    grid_emu_data.Inom_trafo = grid_emu_data.Ptrafo/Vline2/sqrt(3);
    grid_emu_data.Ld2_trafo= grid_emu_data.Vphase2/(100/grid_emu_data.Vcc_perc)/grid_emu_data.Inom_trafo/(grid_emu_data.w_grid); %leakage inductace
    grid_emu_data.Rd2_trafo = 0.05*grid_emu_data.Ptrafo/3/grid_emu_data.Inom_trafo^2; 
    grid_emu_data.Lmu2_trafo= grid_emu_data.Vphase2/grid_emu_data.I0/(grid_emu_data.w_grid); %magentization inductance
    grid_emu_data.Piron = 1.4e3;
    grid_emu_data.Rm2_trafo = grid_emu_data.Vphase2^2/(grid_emu_data.Piron/3);
    grid_emu_data.psi_trafo = grid_emu_data.Lmu2_trafo*grid_emu_data.I0*sqrt(2);
    
    %% grid emulator others data
    grid_emu_data.kp_vgrid = 10;
    grid_emu_data.ki_vgrid = 45;
    grid_emu_data.k_ff = 1;
    
    %% voltage reference grid emulator
    if (application690 == application_voltage)
        Igrid_phase_normalization_factor = 270*sqrt(2);
    elseif (application480 == application_voltage)
        Igrid_phase_normalization_factor = 360*sqrt(2);
    else
        Igrid_phase_normalization_factor = 360*sqrt(2);
    end
    grid_emu_data.Vgrid_phase_normalization_factor = grid_emu_data.Vphase2*sqrt(2);
    grid_emu_data.I_phase_normalization_factor = Igrid_phase_normalization_factor; % misura della corrente 
    grid_emu_data.V_phase_normalization_factor = grid_emu_data.Vgrid_phase_normalization_factor; % misura della tensione dopo il trafo
    grid_emu_data.ugrid_factor = 1;
    
    if (application690 == application_voltage)
        Vemu_ref = 690/sqrt(3); % tensione di fase rms di riferimento in uscita al trafo
        Vemu_ref_norm = Vemu_ref * sqrt(2) / grid_emu_data.V_phase_normalization_factor;
    elseif (application480 == application_voltage)
        Vemu_ref = 480/sqrt(3); % tensione di fase rms di riferimento in uscita al trafo
        Vemu_ref_norm = Vemu_ref * sqrt(2) / grid_emu_data.V_phase_normalization_factor;
    else
        Vemu_ref = 400/sqrt(3); % tensione di fase rms di riferimento in uscita al trafo
        Vemu_ref_norm = Vemu_ref * sqrt(2) / grid_emu_data.V_phase_normalization_factor;
    end
    
    grid_emu_data.Vemu_ref = Vemu_ref;
    grid_emu_data.Vemu_ref_norm = Vemu_ref_norm;
    grid_emu_data.Vdclink_nom = Vdclink_nom;

end
