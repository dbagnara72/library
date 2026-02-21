
%% Extended Kalman Filter for PSM Observer

        %% example of application
        % psm_ctrl.ekf = ekf_pmsm_setup(psm.Rs_norm, psm.Ls_norm, glb_time.ts_inv);

classdef ekf_pmsm_setup
    properties
        A1_tilde_ekf
        A2_tilde_ekf
        A3_tilde_ekf
        A4_tilde_ekf
        B_tilde_ekf
        C_ekf
        Bd_ekf
        Qkalman
        Rkalman
        k_kalman
        k_dc
        k_sw
        
        Rs_norm_ekf
        Lalpha_norm_ekf
        Lbeta_norm_ekf
        ts
    end
    
    methods
        function obj = ekf_pmsm_setup(rs_norm, ls_norm, ts)
            if nargin > 0
                obj.Rs_norm_ekf = rs_norm;
                obj.Lalpha_norm_ekf = ls_norm;
                obj.Lbeta_norm_ekf = ls_norm;
                obj.ts = ts;
                
                
                obj.A1_tilde_ekf = [-obj.Rs_norm_ekf/obj.Lalpha_norm_ekf 0 0 0 0 0; 0 -obj.Rs_norm_ekf/obj.Lalpha_norm_ekf 0 0 0 0; ...
                    0 0 0 0 0 0; 0 0 0 0 0 0; ...
                    0 0 0 0 0 1; 0 0 0 0 0 0];
                
                obj.A2_tilde_ekf = [0 0 0 1/obj.Lbeta_norm_ekf 0 0; 0 0 -1/obj.Lbeta_norm_ekf 0 0 0; ...
                    0 0 0 -1 0 0; 0 0 1 0 0 0;...
                    0 0 0 0 0 0; 0 0 0 0 0 0];
                
                obj.A3_tilde_ekf = [0 0 0 0 0 0; 0 0 0 0 0 -1/obj.Lbeta_norm_ekf; ...
                    0 0 0 0 0 0; 0 0 0 0 0 1;...
                    0 0 0 0 0 0; 0 0 0 0 0 0];
                
                obj.A4_tilde_ekf = [0 0 0 0 0 1/obj.Lalpha_norm_ekf; 0 0 0 0 0 0; ...
                    0 0 0 0 0 -1; 0 0 0 0 0 0;...
                    0 0 0 0 0 0; 0 0 0 0 0 0];
                
                obj.B_tilde_ekf = [1/obj.Lalpha_norm_ekf 0; 0 1/obj.Lbeta_norm_ekf; 0 0; 0 0; 0 0; 0 0];
                
                obj.C_ekf = [1 0 0 0 0 0; 0 1 0 0 0 0];
                obj.Bd_ekf = obj.B_tilde_ekf * obj.ts;
                
                %% Kalman init
                obj.Qkalman = obj.ts * [obj.Rs_norm_ekf/obj.Lalpha_norm_ekf 0 0 0 0 0; 0 obj.Rs_norm_ekf/obj.Lbeta_norm_ekf 0 0 0 0; ...
                    0 0 1 0 0 0;...
                    0 0 0 1 0 0;...
                    0 0 0 0 1 0;...
                    0 0 0 0 0 1];
                obj.Rkalman = [2 0; 0 2];
                
                obj.k_kalman = 1;
                obj.k_dc = 0;
                obj.k_sw = 0;
            end
        end
    end
end












