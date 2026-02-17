
%% example
% psm = pmsm_setup('generic 1500 kW wind generator', 1600e3, 690, 690, 690, 50, 95, 5.6, 10, 1200, 1,0,0,0);

%% class definition
classdef pmsm_setup
    properties
        name                string
        pwr_nom             double {mustBePositive} % Nominal power [W]
        u_nom               double {mustBePositive} % Transformer nominal secondary side voltage [V]
        rpm_nom             double {mustBePositive} % Transformer nominal primary side current [A]
        number_poles        double {mustBePositive} % Transformer nominal primary side voltage [V]
        eta                 double {mustBePositive} % Nominal frequency [Hz]
        Ld                  double {mustBePositive} % Transformer short circuit voltage [%]
        Lq                  double {mustBePositive} % Transformer short circuit voltage [%]
        Lmu                 double {mustBePositive} % Transformer short circuit voltage [%]
        Jm                  double {mustBePositive} % Transformer short circuit voltage [%]
        h5_percent_psm      double {mustBePositive} % Nominal pulsation [rad/s]
        h7_percent_psm      double {mustBePositive} % Nominal pulsation [rad/s]
        
        i_nom               double {mustBePositive} % Nominal pulsation [rad/s]
        ibez                double {mustBePositive} % Nominal pulsation [rad/s]
        ubez                double {mustBePositive} % Transformer efficiency [%]
        freq_bez            double {mustBePositive} % Transformer efficiency [%]
        omega_bez           double {mustBePositive} % Transformer efficiency [%]
        omega_m_bez         double {mustBePositive} % Transformer efficiency [%]
        psi_m               double {mustBePositive} % Transformer short circuit voltage [%]
        psi_bez             double {mustBePositive} % Transformer short circuit voltage [%]
        Rs                  double {mustBePositive} % Transformer short circuit voltage [%]
        La                  double {mustBePositive} % Transformer short circuit voltage [%]
        Lb                  double {mustBePositive} % Transformer short circuit voltage [%]
        Lalpha              double {mustBePositive} % Transformer short circuit voltage [%]
        Lbeta               double {mustBePositive} % Transformer short circuit voltage [%]
        Ls                  double {mustBePositive} % Transformer short circuit voltage [%]

        Xbez                double {mustBePositive} % Transformer short circuit voltage [%]
        Lbez                double {mustBePositive} % Transformer short circuit voltage [%]
        Rs_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Ld_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Lq_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Ls_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Lalpha_norm         double {mustBePositive} % Transformer short circuit voltage [%]
        Lbeta_norm          double {mustBePositive} % Transformer short circuit voltage [%]
        La_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Lb_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        psi_m_norm          double {mustBePositive} % Transformer short circuit voltage [%]
        Jm_norm             double {mustBePositive} % Transformer short circuit voltage [%]
    end
    
        pwr_nom             double {mustBePositive} % Nominal power [W]
        u_nom               double {mustBePositive} % Transformer nominal secondary side voltage [V]
        rpm_nom             double {mustBePositive} % Transformer nominal primary side current [A]
        number_poles        double {mustBePositive} % Transformer nominal primary side voltage [V]
        eta                 double {mustBePositive} % Nominal frequency [Hz]
        Ld                  double {mustBePositive} % Transformer short circuit voltage [%]
        Lq                  double {mustBePositive} % Transformer short circuit voltage [%]
        Lmu                 double {mustBePositive} % Transformer short circuit voltage [%]
        Jm                  double {mustBePositive} % Transformer short circuit voltage [%]
        h5_percent_psm      double {mustBePositive} % Nominal pulsation [rad/s]
        h7_percent_psm      double {mustBePositive} % Nominal pulsation [rad/s]

    methods
        function obj = pmsm_setup(name, pwr_nom, u_nom, rpm_nom, number_poles, eta, Ld, Lq, Lmu, Jm, h5_percent, h7_percent)
            if nargin > 0
                obj.name = name;
                obj.pwr_nom = pwr_nom;
                obj.u_nom = u_nom;
                obj.rpm_nom = rpm_nom;
                obj.number_poles = number_poles;
                obj.us_secondary_nom = us2;
                obj.is_secondary_nom = pwr_nom/sqrt(3)/us2;
                obj.fgrid_nom = fgrid;
                obj.ucc = ucc;
                obj.eta = eta;
                obj.i1m = i1m;
                obj.n12 = us1/us2;

                obj.omega_grid_nom = fgrid * 2*pi;
                
                obj.Ld1_trafo = 0.5 * (us1*ucc/100/sqrt(3)/obj.is_primary_nom/obj.omega_grid_nom);
                obj.Rd1_trafo = 0.5 * ((1 - eta/100) * pwr_nom / 3 / obj.is_primary_nom^2); 
                obj.Lm1_trafo = us1/sqrt(3)/i1m/obj.omega_grid_nom;
                
                obj.Ld2_trafo = obj.Ld1_trafo / (obj.n12)^2;
                obj.Rd2_trafo = obj.Rd1_trafo / (obj.n12)^2;
                obj.Lm2_trafo = obj.Lm1_trafo / (obj.n12)^2;
                
                obj.p_iron = p_iron;
                obj.Rfe1_trafo = (us1/sqrt(3))^2/(p_iron/3);
                obj.psi_trafo = obj.Lm1_trafo*obj.i1m*sqrt(2);

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


