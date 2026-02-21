
%% example


%% class definition
classdef ctrl_pmsm_setup
    properties
        ts                      double {mustBePositive} % Samping time [s]
        omega_base              double {mustBePositive} % Base pulsation [s]
    end
    
    methods

        function obj = ctrl_setup(name, pwr_nom, u1_nom, u2_nom, f_nom, eta, ucc, i1m, p_iron)
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

                obj.n1 = 50*sqrt(3);
                obj.n2 = 50;
                
                obj.Ld1 = 0.5 * (obj.u1_nom*obj.ucc/100/sqrt(3)/obj.i1_nom/(2*pi*obj.f_nom));
                obj.Rd1 = 0.5 * ((1 - obj.eta/100) * obj.pwr_nom / 3 / obj.i1_nom^2); 
                obj.Lm1 = obj.u1_nom/sqrt(3)/obj.i1m/(2*pi*obj.f_nom);
                
                obj.Ld2 = obj.Ld1 / (obj.n12)^2;
                obj.Rd2 = obj.Rd1 / (obj.n12)^2;
                obj.Lm2 = obj.Lm1 / (obj.n12)^2;
                
                obj.p_iron = p_iron;
                obj.Rfe1 = (obj.u1_nom/sqrt(3))^2/(obj.p_iron/3);
                obj.psi = obj.Lm1*obj.i1m*sqrt(2);

            end
        end
        
        function out = double_integrator_observer(obj)
                Aso = [0 1; 0 0];
                Asod = eye(2) + Aso*obj.ts;
                Cso = [1 0];
                p2place = [-1 -4]*obj.omega_base;
                p2placed = exp(p2place*obj.ts);
                Kd = (acker(Asod',Cso',p2placed))';
            out.komega = Kd(2) / obj.ts;
            out.ktheta = Kd(1) / obj.ts;
        end

        function out = extended_double_integrator_observer(obj)
                out.A = [0 1 0; 0 0 -1/obj.Jm_norm; 0 0 0];
                out.Ad_edio = eye(3) + A * obj.ts;
                out.Bd_edio = [0; obj.ts/obj.Jm_norm; 0];
                out.Cedio = [1 0 0];
                p3place = exp([-1 -2 -4] * obj.omega_base * obj.ts);
                Klo = (acker(out.Ad_edio',out.Cedio',p3place))';
                out.l1 = Klo(1);
                out.l2 = Klo(2);
                out.l3 = Klo(3);
        end



id_lim = 0.35;

kp_w = 2.5;
ki_w = 18;
iq_lim = 1.4;

kp_i = 0.25;
ki_i = 18;

kp_id = kp_i;
ki_id = ki_i;
kp_iq = kp_i;
ki_iq = ki_i;

kp_inv_d = kp_i;
ki_inv_d = ki_i;
kp_inv_q = kp_i;
ki_inv_q = ki_i;



%% Field Weakening Control 
kp_fw = 0.05;
ki_fw = 1.8;

%% BEMF observer
emf_fb_p = 0.2;
emf_p = emf_fb_p*4/10;

emf_fb_p_ccaller_1 = emf_fb_p;
emf_p_ccaller_1 = emf_fb_p_ccaller_1*4/10;

emf_fb_p_ccaller_2 = emf_fb_p;
emf_p_ccaller_2 = emf_fb_p_ccaller_2*4/10;
% omega_th = 0.25;
omega_th = 0;
    end
end


