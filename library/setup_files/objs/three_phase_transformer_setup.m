
%% example
% name = 'Dyn11-690V-690V-1600kW';
% pwr_nom = 1600e3;
% u1_nom = 690;
% u2_nom = 690;
% f_nom = 50;
% eta = 98;
% ucc = 4.6;
% i1m = 10;
% p_iron = 10e3;
% n2 = 14;
% n1 = floor(n2*sqrt(3));
% core_area = 0.05;
% core_length = 2.5;
% mur = mu0;
% mur = 10e3;
% trafo = three_phase_transformer_setup(name, pwr_nom, u1_nom, u2_nom, f_nom, eta, ucc, ...
% i1m, p_iron, n1, n2, core_area, core_length, mur);

% two simple calculation:
% Lm1 = (n1^2 * mu0 * mur * core_area) / core_length;
% Lm1 = u1_nom/sqrt(3)/i1m/(2*pi*f_nom);

%% class definition
classdef three_phase_transformer_setup
    properties
        name                string
        pwr_nom             double {mustBePositive} % Nominal power [W]
        u1_nom              double {mustBePositive} % Transformer nominal primary side voltage [V]
        i1_nom              double {mustBePositive} % Transformer nominal primary side current [A]
        u2_nom              double {mustBePositive} % Transformer nominal secondary side voltage [V]
        i2_nom              double {mustBePositive} % Transformer nominal secondary side current [A]
        n1                  double {mustBePositive} % Transformer nominal secondary side current [A]
        n2                  double {mustBePositive} % Transformer nominal secondary side current [A]
        f_nom               double {mustBePositive} % Nominal frequency [Hz]
        eta                 double {mustBePositive} % Transformer efficiency [%]
        ucc                 double {mustBePositive} % Transformer short circuit voltage [%]
        i1m                 double {mustBePositive} % Transformer primary side magnetization current [A]
        n12                 double {mustBePositive} % Transformer U1/U2 []
        Rd1                 double {mustBePositive} % Transformer primary side winding resistance [Ohm]
        Lsigma              double {mustBePositive} % Transformer leakage inductance [H]
        Ld1                 double {mustBePositive} % Transformer primary side leakage inductance [H]
        Lm1                 double {mustBePositive} % Transformer primary side magnetization inductance [H]
        Rd2                 double {mustBePositive} % Transformer secondary side winding resistance [Ohm]
        Ld2                 double {mustBePositive} % Transformer secondary side leakage inductance [H]
        Lm2                 double {mustBePositive} % Transformer secondary side magnetization inductance [H]
        p_iron              double {mustBePositive} % Transformer iron losses [W]
        Rfe1                double {mustBePositive} % Transformer primary side equivalent iron losses resistance [Ohm]
        psi                 double {mustBePositive} % Transformer core flux [Vs]
        core_area           double {mustBePositive} % Core Area [m^2]
        core_length         double {mustBePositive} % Core Length [m]
        mu0                 double {mustBePositive} % Air permeability [N/m]
        mur                 double {mustBePositive} % Relative permeability [pu]
    end
    
    methods

        function obj = three_phase_transformer_setup(name, pwr_nom, u1_nom, u2_nom, f_nom, eta, ...
                ucc, i1m, p_iron, n1, n2, core_area, core_length, mur)
            if nargin > 0
                obj.name = name;
                obj.pwr_nom = pwr_nom;
                obj.u1_nom = u1_nom;
                obj.i1_nom = obj.pwr_nom/sqrt(3)/obj.u1_nom;
                obj.u2_nom = u2_nom;
                obj.i2_nom = obj.pwr_nom/sqrt(3)/obj.u2_nom;
                obj.f_nom = f_nom;
                obj.ucc = ucc;
                obj.eta = eta;
                obj.i1m = i1m;
                obj.n12 = obj.u1_nom/obj.u2_nom;

                obj.n1 = n1;
                obj.n2 = n2;
                
                obj.Lsigma = (obj.u1_nom*obj.ucc/100/sqrt(3)/obj.i1_nom/(2*pi*obj.f_nom));
                obj.Ld1 = 3/2 * obj.Lsigma; % Dy transformer
                obj.Rd1 = 0.5 * ((1 - obj.eta/100) * obj.pwr_nom / 3 / obj.i1_nom^2); 
                obj.Lm1 = obj.u1_nom/sqrt(3)/obj.i1m/(2*pi*obj.f_nom);
                
                obj.Ld2 = obj.Lsigma / 2 / (obj.n12)^2;
                obj.Rd2 = obj.Rd1 / (obj.n12)^2;
                obj.Lm2 = obj.Lm1 / (obj.n12)^2;
                
                obj.p_iron = p_iron;
                obj.Rfe1 = (obj.u1_nom/sqrt(3))^2/(obj.p_iron/3);
                obj.psi = obj.Lm1*obj.i1m*sqrt(2);

                obj.core_area = core_area;
                obj.core_length = core_length;
                obj.mu0 = 4*pi*1e-7;
                obj.mur = mur;
            end
        end
        
        function displayInfo(obj)
            fprintf('Three Phase Transformer Setup: %s\n', obj.name);
            fprintf('Primary Side Leakage Inductance: %.2f H | Secondary Side Leakage Inductance: %.2f H\n', obj.Ld1, obj.Ld2);
            fprintf('Primary Side Magnetization Inductance: %.2f H\n', obj.Lm1);
            fprintf('---------------------------\n');
        end
    end
end


