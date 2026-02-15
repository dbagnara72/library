classdef dab
    properties
        name            string
        udc1_nom        double {mustBePositive} % Nominal DC1 voltage [V]
        udc2_nom        double {mustBePositive} % Nominal DC2 voltage [V]
        uac1_nom        double {mustBePositive} % Nominal AC1 voltage [V]
        uac2_nom        double {mustBePositive} % Nominal AC2 voltage [V]
        idc1_nom        double {mustBePositive} % Nominal DC1 current [A]
        idc2_nom        double {mustBePositive} % Nominal DC2 current [A]
        fpwm_base       double {mustBePositive} % Base switching frequency [Hz]
        f0_base         double {mustBePositive} % Base resonance frequency [Hz]
        Cs1             double {mustBePositive} % Primary side resonance capacitor [F]
        Ls1             double {mustBePositive} % Primary side resonance inductance [H]
        n1              double {mustBePositive} % Transformer primary side number of turns
        n2              double {mustBePositive} % Transformer secondary side number of turns
        Lm              double {mustBePositive} % Transformer primary side magnetization inductance [H]
        Rfe             double {mustBePositive} % Transformer equivalent resistance for iron losses [Ohm]
        core_length     double {mustBePositive} % Transformer core length [m]
        core_mur        double {mustBePositive} % Transformer core relative permeability [pu]
        Ld1             double {mustBePositive} % Transformer primary side leakage inductance [H]
        Rs1             double {mustBePositive} % Transformer primary side winding resistance [Ohm]
        Ld2             double {mustBePositive} % Transformer secondary side leakage inductance [H]
        Rs2             double {mustBePositive} % Transformer seconsary side winding resistance [Ohm]
        Cs2             double {mustBePositive} % Secondary side resonance capacitor [F]
        Ls2             double {mustBePositive} % Secondary side resonance inductance [H]
        Cdc_dc1         double {mustBePositive} % DClink capacitor primary side [F]
        Cdc1_dc1        double {mustBePositive} % DClink capacitor primary side bank 1 [F]
        Cdc2_dc1        double {mustBePositive} % DClink capacitor primary side bank 2 [F]
        Cdc_dc2         double {mustBePositive} % DClink capacitor secondary side [F] 
        Cdc1_dc2        double {mustBePositive} % DClink capacitor secondary side bank 1 [F] 
        Cdc2_dc2        double {mustBePositive} % DClink capacitor secondary side bank 2 [F]

        RCdc_dc1        double {mustBePositive} % DClink capacitor primary side internal resistance [Ohm]
        RCdc1_dc1       double {mustBePositive} % DClink capacitor primary side bank 1 internal resistance [Ohm]
        RCdc2_dc1       double {mustBePositive} % DClink capacitor primary side bank 2 internal resistance [Ohm]
        RCdc_dc2        double {mustBePositive} % DClink capacitor secondary side internal resistance [Ohm]
        RCdc1_dc2       double {mustBePositive} % DClink capacitor secondary side bank 1 internal resistance [Ohm]
        RCdc2_dc2       double {mustBePositive} % DClink capacitor secondary side bank 2 internal resistance [Ohm]

        Ldc_dc1         double {mustBePositive} % Input/Output Inductance primary side [H]
        Ldc_dc2         double {mustBePositive} % Input/Output Inductance secondary side [H]

        RLdc_dc1        double {mustBePositive} % Input/Output Inductance primary side internal resistance [Ohm]
        RLdc_dc2        double {mustBePositive} % Input/Output Inductance secondary side internal resistance [Ohm]
        Idc_FS          double {mustBePositive} % Current End Scale [A]
        Udc_FS          double {mustBePositive} % Voltage End Scale [V]
    end
    
    methods
        function obj = dab(name, udc1, udc2, uac1, uac2, idc1, idc2, fpwm, fres, Cs1, Ls1, ...
            n1, n2, Lm, Rfe, Ld1, Ld2, Rs1, Rs2, Cs2, Ls2, core_length, core_mur, Cdc_dc1, Cdc1_dc1, Cdc2_dc1, Cdc_dc2, ...
            Cdc1_dc2, Cdc2_dc2, RCdc_dc1, RCdc1_dc1, RCdc2_dc1, RCdc_dc2, RCdc1_dc2, RCdc2_dc2, ...
            Ldc_dc1, Ldc_dc2, RLdc_dc1, RLdc_dc2, idc_FS, udc_FS)
            if nargin > 0
                obj.name = name;
                obj.udc1_nom = udc1;
                obj.udc2_nom = udc2;
                obj.uac1_nom = uac1;
                obj.uac2_nom = uac2;
                obj.idc1_nom = idc1;
                obj.idc2_nom = idc2;
                obj.fpwm_base = fpwm;
                obj.f0_base = fres;
                
                obj.Cs1 = Cs1;
                obj.Ls1 = Ls1;
                obj.n1 = n1;
                obj.n2 = n2;
                obj.Lm = Lm;
                obj.Rfe = Rfe;
                obj.Ld1 = Ld1;
                obj.Ld2 = Ld2;
                obj.Rs1 = Rs1;
                obj.Rs2 = Rs2;
                obj.Cs2 = Cs2;
                obj.Ls2 = Ls2;

                obj.core_length = core_length;
                obj.core_mur = core_mur;

                obj.Cdc_dc1 = Cdc_dc1;
                obj.Cdc1_dc1 = Cdc1_dc1;
                obj.Cdc2_dc1 = Cdc2_dc1;

                obj.Cdc_dc2 = Cdc_dc2;
                obj.Cdc1_dc2 = Cdc1_dc2;
                obj.Cdc2_dc2 = Cdc2_dc2;

                obj.RCdc_dc1 = RCdc_dc1;
                obj.RCdc1_dc1 = RCdc1_dc1;
                obj.RCdc2_dc1 = RCdc2_dc1;

                obj.RCdc_dc2 = RCdc_dc2;
                obj.RCdc1_dc2 = RCdc1_dc2;
                obj.RCdc2_dc2 = RCdc2_dc2;

                obj.Ldc_dc1 = Ldc_dc1;
                obj.Ldc_dc2 = Ldc_dc2;
                obj.RLdc_dc1 = RLdc_dc1;
                obj.RLdc_dc2 = RLdc_dc2;

                obj.Idc_FS = idc_FS;
                obj.Udc_FS = udc_FS;
            end
        end
        
        function idc1_bez = get_normalization_dc1_current_value(obj)
            idc1_bez =  obj.idc1_nom;
        end
        function idc2_bez = get_normalization_dc2_current_value(obj)
            idc2_bez =  obj.idc2_nom;
        end
        function udc1_bez = get_normalization_dc1_voltage_value(obj)
            udc1_bez =  obj.udc1_nom;
        end
        function udc2_bez = get_normalization_dc2_voltage_value(obj)
            udc2_bez =  obj.udc2_nom;
        end


        function displayInfo(obj)
            fprintf('Device DAB: %s\n', obj.name);
            fprintf('Normalization Voltage DC1: %d V | Normalization Current DC1: %d A\n', ...
                obj.get_normalization_dc1_voltage_value(), obj.get_normalization_dc1_current_value());
            fprintf('Normalization Voltage DC2: %d V | Normalization Current DC2: %d A\n', ...
                obj.get_normalization_dc2_voltage_value(), obj.get_normalization_dc2_current_value());
            fprintf('---------------------------\n');
        end
    end
end