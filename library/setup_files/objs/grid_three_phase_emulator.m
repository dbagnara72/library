
%% example
% grid = grid_three_phase_emulator('wind_grid', 1600e3, 690, 690, 690, 50, 95, 5.6, 10, 1200, 1,0,0,0);

%% class definition
classdef grid_three_phase_emulator
    properties
        name                string
        pwr_nom             double {mustBePositive} % Nominal power [W]
        application_voltage double {mustBePositive} % application voltage: 690V, 480V or 400V [V]
        us_primary_nom      double {mustBePositive} % Transformer nominal primary side voltage [V]
        is_primary_nom      double {mustBePositive} % Transformer nominal primary side current [A]
        us_secondary_nom    double {mustBePositive} % Transformer nominal secondary side voltage [V]
        is_secondary_nom    double {mustBePositive} % Transformer nominal secondary side current [A]
        n1                  double {mustBePositive} % Transformer nominal secondary side current [A]
        n2                  double {mustBePositive} % Transformer nominal secondary side current [A]
        fgrid_nom           double {mustBePositive} % Nominal frequency [Hz]
        omega_grid_nom      double {mustBePositive} % Nominal pulsation [rad/s]
        trafo
        udc_nom             double {mustBePositive} % Nominal DC-link voltage [V]

        i1bez               double {mustBePositive} % Normalization Current Factor primary side transformer [A]
        u1bez               double {mustBePositive} % Normalization Voltage Factor primary side transformer [V]
        i2bez               double {mustBePositive} % Normalization Current Factor secondary side transformer [A]
        u2bez               double {mustBePositive} % Normalization Voltage Factor secondary side transformer [V]
        
        up_xi_pu_ref        double {} % Positive xi voltage reference [pu]
        up_eta_pu_ref       double {} % Positive eta voltage reference [pu]
        un_xi_pu_ref        double {} % Negative xi voltage reference [pu]
        un_eta_pu_ref       double {} % Negative eta voltage reference [pu]

        ugrid_factor        double {mustBePositive} % Parameter for grid emulator control [pu]
        kp_vgrid            double {mustBePositive} % Parameter for grid emulator control [pu]
        ki_vgrid            double {mustBePositive} % Parameter for grid emulator control [pu]
        k_ff                double {mustBePositive} % Parameter for grid emulator control [pu]
        igrid_bez           double {mustBePositive} % Normalization factor for grid quantities (secondary side) [A]
        ugrid_bez           double {mustBePositive} % Normalization factor for grid quantities (secondary side) [V]
        Vemu_ref            double {mustBePositive} % Grid Emulator Voltage Reference [V]
        Vemu_ref_norm       double {mustBePositive} % Grid Emulator Voltage Reference [pu]
    end
    
    methods

        function obj = grid_three_phase_emulator(name, pwr_nom, application_voltage, us1, us2, fgrid, ...
                eta, ucc, i1m, p_iron, up_xi_pu_ref, up_eta_pu_ref, un_xi_pu_ref, un_eta_pu_ref)
            if nargin > 0
                obj.name = name;
                obj.application_voltage = application_voltage;
                obj.pwr_nom = pwr_nom;
                obj.us_primary_nom = us1;
                obj.is_primary_nom = pwr_nom/sqrt(3)/us1;
                obj.us_secondary_nom = us2;
                obj.is_secondary_nom = pwr_nom/sqrt(3)/us2;
                obj.fgrid_nom = fgrid;
                obj.omega_grid_nom = fgrid * 2*pi;
                obj.trafo =  three_phase_transformer_setup(obj.name, obj.pwr_nom, obj.us_primary_nom, ...
                    obj.us_secondary_nom, obj.fgrid_nom, eta, ucc, i1m, p_iron);

                obj.u1bez =  obj.us_primary_nom * sqrt(2/3);
                obj.i1bez =  obj.is_primary_nom * sqrt(2);
                obj.u1bez =  obj.us_secondary_nom * sqrt(2/3);
                obj.i1bez =  obj.is_secondary_nom * sqrt(2);

                obj.kp_vgrid = 10;
                obj.ki_vgrid = 45;
                obj.k_ff = 1;
                obj.ugrid_factor = 1;

                obj.up_xi_pu_ref = up_xi_pu_ref;
                obj.up_eta_pu_ref = up_eta_pu_ref;
                obj.un_xi_pu_ref = un_xi_pu_ref;
                obj.un_eta_pu_ref = un_eta_pu_ref;

                %% voltage reference grid emulator
                if (application_voltage == 690)
                    obj.igrid_bez = 270*sqrt(2);
                    obj.ugrid_bez = 690*sqrt(2/3);
                    obj.udc_nom = 1070;
                elseif (application_voltage == 480)
                    obj.igrid_bez = 360*sqrt(2);
                    obj.ugrid_bez = 480*sqrt(2/3);
                    obj.udc_nom = 750;
                else
                    obj.igrid_bez = 360*sqrt(2);
                    obj.ugrid_bez = 400*sqrt(2/3);
                    obj.udc_nom = 680;
                end
                
                if (application_voltage == 690)
                    obj.Vemu_ref = 690/sqrt(3) * obj.ugrid_factor;
                    obj.Vemu_ref_norm = obj.Vemu_ref * sqrt(2) / obj.ugrid_bez;
                elseif (application_voltage == 480)
                    obj.Vemu_ref = 480/sqrt(3) * obj.ugrid_factor;
                    obj.Vemu_ref_norm = obj.Vemu_ref * sqrt(2) / obj.ugrid_bez;
                else
                    obj.Vemu_ref = 400/sqrt(3) * obj.ugrid_factor;
                    obj.Vemu_ref_norm = obj.Vemu_ref * sqrt(2) / obj.ugrid_bez;
                end
                

            end
        end
        
        function displayInfo(obj)
            fprintf('Three phase grid emulator with transformer parameters derivation: %s\n', obj.name);
            fprintf('Nominal Voltage: %d V | Nominal Current: %d A\n', obj.us_secondary_nom, obj.is_secondary_nom);
            fprintf('Current Normalization Data: %.2f A\n', obj.igrid_bez);
            fprintf('Voltage Normalization Data: %.2f V\n', obj.ugrid_bez);
            fprintf('---------------------------\n');
        end
    end
end


