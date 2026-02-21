
%% example


%% class definition
classdef ctrl_afe_setup
    properties
        ts                      double {mustBePositive} % Samping time [s]
        omega_base              double {mustBePositive} % Base pulsation [s]
        omega_diobs_grid_phase  double {mustBePositive} % Double Integrator Observer - base pulsation [s]
        diobj                   % Double Integrator Observer Object 
        fht_grid                % First harmonic Tracker Object for Grid application 
        fht_load                % First harmonic Tracker Object for Load application 
        res_pi                  % Resonant PI Object for grid current control 
      
        udc_norm_ref
        kp_udc_ctrl
        ki_udc_ctrl
        kp_is_xi
        ki_is_xi
        kp_is_eta
        ki_is_eta
        kp_ig_xi
        ki_ig_xi
        kp_ig_eta
        ki_ig_eta
               
        kp_rc_grid
        ki_rc_grid
        kp_rc_pos_grid
        ki_rc_pos_grid
        kp_rc_neg_grid
        ki_rc_neg_grid

        pll_i1
        pll_p
        pll_p_frt
        pll_i1_ddsrt
        pll_p_ddsrt
        tau_ddsrf
        pll_i1_fht
        pll_p_fht

        umax_ff
        ixi_pos_ref_lim
        ieta_pos_ref_lim
        ieta_neg_ref_lim

        i_grid_pos_eta_lim
        i_grid_neg_xi_lim
        i_grid_neg_eta_lim

        i_grid_pos_eta_red_lim
        i_grid_neg_eta_red_lim
        i_grid_neg_xi_red_lim
        rms
    end
    
    methods

        function obj = ctrl_afe_setup(ts, omega_base)
            if nargin > 0
                obj.ts = ts;
                obj.omega_base = omega_base;

                obj.diobj = double_integrator_observer(obj);
                obj.fht_grid = first_harmonic_tracker(obj);
                obj.fht_load = first_harmonic_tracker(obj);
                obj.res_pi = resonant_pi(obj);
                obj.rms = rms_setup(obj);

                %% PLL gains
                obj.pll_i1 = 80;
                obj.pll_p = 1;
                obj.pll_p_frt = 0.2;

                %% PLL DDSRF
                obj.pll_i1_ddsrt = obj.pll_i1;
                obj.pll_p_ddsrt = obj.pll_p;
                obj.tau_ddsrf = 1/obj.omega_base;

                %% PLL FHT (First Harmonic Tracker)
                obj.pll_i1_fht = obj.pll_i1;
                obj.pll_p_fht = obj.pll_p;


                obj.udc_norm_ref = 1;
                obj.kp_udc_ctrl = 0.85;
                obj.ki_udc_ctrl = 35;

                obj.kp_is_xi = 0.25;
                obj.ki_is_xi = 45;
                obj.kp_is_eta = 0.25;
                obj.ki_is_eta = 45;
                obj.kp_ig_xi = 0.25;
                obj.ki_ig_xi = 35;
                obj.kp_ig_eta = 0.25;
                obj.ki_ig_eta = 35;

                obj.kp_rc_grid = 0.25;
                obj.ki_rc_grid = 35;
                obj.kp_rc_pos_grid = obj.kp_rc_grid;
                obj.ki_rc_pos_grid = obj.ki_rc_grid;
                obj.kp_rc_neg_grid = obj.kp_rc_grid;
                obj.ki_rc_neg_grid = obj.ki_rc_grid;

                obj.umax_ff = 1.1;
                obj.ixi_pos_ref_lim = 1.65;
                obj.ieta_pos_ref_lim = 1.0;
                obj.ieta_neg_ref_lim = 0.5;

                obj.i_grid_pos_eta_lim = 1;
                obj.i_grid_neg_xi_lim = 0.5;
                obj.i_grid_neg_eta_lim = 0.5;
                obj.i_grid_pos_eta_red_lim = 0.1;
                obj.i_grid_neg_eta_red_lim = 0.1;
                obj.i_grid_neg_xi_red_lim = 0.1;
                
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
        
        function out = first_harmonic_tracker(obj)
                omega_fht = obj.omega_base;
                delta_fht = 0.05;
                Afht = [0 1; -omega_fht^2 -delta_fht*omega_fht];
                Cfht = [1 0];
                poles_fht = [-1 -4] * omega_fht;
                Ad_fht = eye(2) + Afht * obj.ts;
                polesd_fht = exp(obj.ts * poles_fht);
            out.L_fht = acker(Afht',Cfht', poles_fht)';
            out.Ld_fht = acker(Ad_fht',Cfht', polesd_fht);
        end

        function out = resonant_pi(obj)
            out.kp_rpi = 0.2;
            out.ki_rpi = 45;
            out.delta_res = 0.015;            
            out.Ares = [0 1; -obj.omega_base^2 -2*out.delta_res*obj.omega_base];
            out.Bres = [0; 1];
            out.Cres = [0 1];
            out.Aresd = eye(2) + Ares*obj.ts;
            out.Bresd = out.Bres*obj.ts;
            out.Cresd = out.Cres;
        end

        function out = rms_setup(obj)
            out.rms_perios = 1;
            out.n1 = 2*pi*rms_perios/obj.omega_base/obj.ts;
            out.rms_perios = 10;
            out.n10 = 2*pi*rms_perios/obj.omega_base/obj.ts;
        end

    end
end


