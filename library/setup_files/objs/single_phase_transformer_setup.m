
%% example
% name = 'Load Single Phase Transformer';
% pwr_nom = 170e3;
% u1_nom = 690;
% n1 = 50;
% n2 = 1;
% u2_nom = u1_nom/n1*n2;
% f_nom = 50;
% eta = 98;
% ucc = 2;
% i1m = 10;
% p_iron = 5e3;
% trafo = single_phase_transformer_setup(name, pwr_nom, u1_nom, u2_nom, n1, n2, f_nom, eta, ucc, i1m, p_iron);

%% class definition
classdef single_phase_transformer_setup
    properties
        name        string
        pwr_nom     double {mustBePositive} % Nominal power [W]
        u1_nom      double {mustBePositive} % Transformer nominal primary side voltage [V]
        i1_nom      double {mustBePositive} % Transformer nominal primary side current [A]
        u2_nom      double {mustBePositive} % Transformer nominal secondary side voltage [V]
        i2_nom      double {mustBePositive} % Transformer nominal secondary side current [A]
        n1          double {mustBePositive} % Transformer nominal secondary side current [A]
        n2          double {mustBePositive} % Transformer nominal secondary side current [A]
        f_nom       double {mustBePositive} % Nominal frequency [Hz]
        eta         double {mustBePositive} % Transformer efficiency [%]
        ucc         double {mustBePositive} % Transformer short circuit voltage [%]
        i1m         double {mustBePositive} % Transformer primary side magnetization current [A]
        n12         double {mustBePositive} % Transformer U1/U2 []
        Rd1         double {mustBePositive} % Transformer primary side winding resistance [Ohm]
        Ld1         double {mustBePositive} % Transformer primary side leakage inductance [H]
        Lm1         double {mustBePositive} % Transformer primary side magnetization inductance [H]
        Rd2         double {mustBePositive} % Transformer secondary side winding resistance [Ohm]
        Ld2         double {mustBePositive} % Transformer secondary side leakage inductance [H]
        Lm2         double {mustBePositive} % Transformer secondary side magnetization inductance [H]
        p_iron      double {mustBePositive} % Transformer iron losses [W]
        Rfe1        double {mustBePositive} % Transformer primary side equivalent iron losses resistance [Ohm]
        psi         double {mustBePositive} % Transformer core flux [Vs]
    end
    
    methods

        function obj = single_phase_transformer_setup(name, pwr_nom, u1_nom, u2_nom, n1, n2, f_nom, eta, ucc, i1m, p_iron)
            if nargin > 0
                obj.name = name;
                obj.pwr_nom = pwr_nom;
                obj.u1_nom = u1_nom;
                obj.i1_nom = obj.pwr_nom/obj.u1_nom;
                obj.u2_nom = u2_nom;
                obj.i2_nom = obj.pwr_nom/obj.u2_nom;
                obj.f_nom = f_nom;
                obj.ucc = ucc;
                obj.eta = eta;
                obj.i1m = i1m;
                obj.n12 = n1/n2;

                obj.n1 = n1;
                obj.n2 = n2;
                
                obj.Ld1 = 0.5 * (obj.u1_nom*obj.ucc/100/obj.i1_nom/(2*pi*obj.f_nom));
                obj.Rd1 = 0.5 * ((1 - obj.eta/100) * obj.pwr_nom / obj.i1_nom^2); 
                obj.Lm1 = obj.u1_nom/obj.i1m/(2*pi*obj.f_nom);
                
                obj.Ld2 = obj.Ld1 / (obj.n12)^2;
                obj.Rd2 = obj.Rd1 / (obj.n12)^2;
                obj.Lm2 = obj.Lm1 / (obj.n12)^2;
                
                obj.p_iron = p_iron;
                obj.Rfe1 = (obj.u1_nom)^2/(obj.p_iron);
                obj.psi = obj.Lm1*obj.i1m*sqrt(2);

            end
        end
        
        function displayInfo(obj)
            fprintf('Single Phase Transformer Setup: %s\n', obj.name);
            fprintf('Primary Side Leakage Inductance: %.2f H | Secondary Side Leakage Inductance: %.2f H\n', obj.Ld1, obj.Ld2);
            fprintf('Primary Side Magnetization Inductance: %.2f H\n', obj.Lm1);
            fprintf('---------------------------\n');
        end
    end
end


