
%% example of application
% im = im_setup(name, pwr_nom, i_nom, rpm_nom, number_poles, eta, Ld, Lq, Jm, h5_percent, h7_percent)
% im = im_setup('WindGen', 1600e3, 2062, 17.8, 104, 96, 1.26e-3, 1.04e-3, 900e3, 0, 0);
% displayInfo(psm);

%% class definition
classdef im_setup
    properties
        name                string
        pwr_nom             double {mustBePositive} % Nominal power [W]
        u_nom               double {mustBePositive} % Nominal voltage [V]
        i_nom               double {mustBePositive} % Nominal current [A]
        freq_nom            double {mustBePositive} % Nominal frequency [Hz]
        rpm_load            double {mustBePositive} % Load rpm [rpm]
        number_poles        double {mustBePositive} % Number of poles
        eta                 double {mustBePositive} % Efficiency [%]
        cosphi              double {mustBePositive} % cosphi [pu]
        u_noload            double {mustBePositive} % No load current [A]
        i_noload            double {mustBePositive} % No load current [A]
        f_noload            double {mustBePositive} % No load current [A]
        u_cc                double {mustBePositive} % Transformer short circuit voltage [%]
        i_cc                double {mustBePositive} % Transformer short circuit voltage [%]
        f_cc                double {mustBePositive} % Transformer short circuit voltage [%]
        Jm                  double {mustBePositive} % Transformer short circuit voltage [%]
        load_friction       double {mustBePositive} % Transformer short circuit voltage [%]

        torque_nom          double {mustBePositive} % Transformer short circuit voltage [%]
        
           
        Xbez                double {mustBePositive} % Transformer short circuit voltage [%]
        Lbez                double {mustBePositive} % Transformer short circuit voltage [%]
        Rs_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Ls_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Lm_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Lr_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Rr_norm             double {mustBePositive} % Transformer short circuit voltage [%]
        Jm_norm             double {mustBePositive} % Transformer short circuit voltage [%]

    end
    
    methods
        function obj = pmsm_setup(name, number_of_systems, pwr_nom, i_nom, rpm_nom, number_poles, eta, Ld, Lq, Jm, h5_percent, h7_percent)
            if nargin > 0
                obj.name = name;
                obj.number_of_systems = number_of_systems;
                obj.pwr_nom = pwr_nom;
                obj.rpm_nom = rpm_nom;
                obj.omega_m_bez = obj.rpm_nom / 60 *2*pi;
                obj.torque_nom = obj.pwr_nom/obj.omega_m_bez;
                obj.i_nom = i_nom;
                obj.number_poles = number_poles;
                obj.eta = eta;
                obj.Ld = Ld;
                obj.Lq = Lq;
                obj.Jm = Jm;
                obj.h5_percent_psm = h5_percent;
                obj.h7_percent_psm = h7_percent;

                obj.Lmu = 5e-6;
                obj.Rs = (obj.pwr_nom / 3) * (1 - obj.eta/100) / (obj.i_nom)^2;       
                obj.Rs_m = obj.Rs * obj.number_of_systems;       
                obj.La = 1/3*(obj.Lq + obj.Ld);   
                obj.Lb = 1/3*(obj.Lq - obj.Ld);  
                obj.Lalpha = (obj.Ld + obj.Lq)/2;   
                obj.Lbeta = obj.Lalpha;
                obj.Ls = obj.Lalpha;    
                
                obj.Ld_m = obj.Ld * obj.number_of_systems;     
                obj.Lq_m = obj.Lq * obj.number_of_systems;     
                obj.Ls_m = obj.Ls * obj.number_of_systems;     
                obj.Lalpha_m = obj.Lalpha * obj.number_of_systems;     
                obj.Lbeta_m = obj.Lbeta * obj.number_of_systems;     
                obj.La_m = obj.La * obj.number_of_systems;     
                obj.Lb_m = obj.Lb * obj.number_of_systems;     
                obj.Jm_m = obj.Jm / obj.number_of_systems;    

                obj.pp = obj.number_poles/2;
                obj.ibez = obj.i_nom / obj.number_of_systems * sqrt(2);
                obj.tau_bez = obj.torque_nom / obj.number_of_systems;
                obj.psi_m = obj.torque_nom /obj.number_of_systems / (3/2*obj.pp*obj.ibez);
                obj.psi_bez = obj.psi_m;
                obj.omega_bez = obj.omega_m_bez * obj.pp;         
                obj.freq_bez = obj.omega_bez / (2*pi);             
                obj.ubez = obj.psi_bez * obj.omega_bez;
                obj.u_nom = obj.ubez / sqrt(2/3);

                obj.Xbez = obj.ubez / obj.ibez;      
                obj.Lbez =  obj.Xbez / obj.omega_bez;    
                obj.Rs_norm = obj.Rs_m / obj.Xbez;
                obj.Ld_norm = obj.Ld_m / obj.Lbez;
                obj.Lq_norm = obj.Lq_m / obj.Lbez;
                obj.Ls_norm = obj.Ls_m / obj.Lbez;
                obj.Lalpha_norm = obj.Lalpha_m / obj.Lbez;
                obj.Lbeta_norm = obj.Lbeta_m / obj.Lbez;
                obj.La_norm = obj.La_m / obj.Lbez;
                obj.Lb_norm = obj.Lb_m / obj.Lbez;
                obj.psi_m_norm = obj.psi_m / obj.psi_bez;
                obj.Jm_norm = 1/2*obj.Jm*obj.omega_m_bez/obj.torque_nom; 

                obj.load_friction = obj.torque_nom / obj.omega_m_bez;
                obj.load_friction_m = obj.load_friction / obj.number_of_systems;
            end
        end
        
        function displayInfo(obj)
            fprintf('Permanent Magnet Synchronous Machine: %s\n', obj.name);
            fprintf('PSM Normalization Voltage Factor: %.1f V | PSM Normalization Current Factor: %.1f A\n', obj.ubez, obj.ibez);
            fprintf('Per-System Direct Axis Inductance: %.5f H\n', obj.Ld_m);
            fprintf('Per-System Quadrature Axis Inductance: %.5f H\n', obj.Lq_m);
            fprintf('---------------------------\n');
        end
    end
end


