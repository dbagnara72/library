
%% Extended Kalman Filter for IM Observer

        %% example of application
        % im_ctrl.ekf = ekf_im_setup(im.alpha_norm, im.beta_norm, im.gamma_norm, im.sigma_norm, im.Lm_norm, glb_time.ts_inv);

classdef ekf_im_setup
    properties
        A_tilde_ekf
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
        
        alpha
        beta
        gamma
        lm
        ts
    end
    
    methods
        function obj = ekf_im_setup(alpha, beta, gamma, sigma, lm, ts)
            if nargin > 0
                obj.alpha = alpha;
                obj.beta = beta;
                obj.gamma = gamma;
                obj.lm = lm;
                obj.ts = ts;
                
                obj.A1_tilde_ekf = [-gamma 0 beta*alpha 0 0 0; ...
                                    0 -gamma 0 beta*alpha 0 0; ...
                                    alpha*lm 0 -alpha 0 0 0; ...
                                    0 alpha*lm 0 -alpha 0 0; ...
                                    0 0 0 0 0 0; ...
                                    0 0 0 0 1 0];
                
                obj.A2_tilde_ekf = [0 0 0 beta 0 0; ...
                                    0 0 -beta 0 0 0; ...
                                    0 0 0 -1 0 0; ...
                                    0 0 1 0 0 0; ...
                                    0 0 0 0 0 0; ...
                                    0 0 0 0 0 0];
                
                obj.A3_tilde_ekf = [0 0 0 0 0 0; ...
                                    0 0 0 0 -beta 0; ...
                                    0 0 0 0 0 0; ...
                                    0 0 0 0 1 0; ...
                                    0 0 0 0 0 0; ...
                                    0 0 0 0 0 0];
                
                obj.A4_tilde_ekf = [0 0 0 0 beta 0; ...
                                    0 0 0 0 0 0; ...
                                    0 0 0 0 -1 0; ...
                                    0 0 0 0 0 0; ...
                                    0 0 0 0 0 0; ...
                                    0 0 0 0 0 0];
                
                obj.B_tilde_ekf = [1/sigma 0; 0 1/sigma; 0 0; 0 0; 0 0; 0 0];
                
                obj.C_ekf = [1 0 0 0 0 0; 0 1 0 0 0 0];
                obj.Bd_ekf = obj.B_tilde_ekf * obj.ts;
                
                obj.A_tilde_ekf = obj.A1_tilde_ekf + obj.A2_tilde_ekf + obj.A3_tilde_ekf + obj.A4_tilde_ekf;
                %% Kalman init
                Qkalman = [ts^2 0 0 0 0 0; ...
                               0 ts^2 0 0 0 0; ...
                               0 0 ts 0 0 0;...
                               0 0 0 ts 0 0;...
                               0 0 0 0 1 0;...
                               0 0 0 0 0 1];
                % Qkalman = [1 0 0 0 0 0; ...
                %                0 1 0 0 0 0; ...
                %                0 0 1 0 0 0;...
                %                0 0 0 1 0 0;...
                %                0 0 0 0 ts 0;...
                %                0 0 0 0 0 ts];                
                obj.Qkalman = obj.ts * Qkalman;
                % obj.Qkalman = Qkalman;
                obj.Rkalman = obj.ts * [1 0; 0 1];
                % obj.Rkalman = [1 0; 0 1];
                
                obj.k_kalman = 1;
                obj.k_dc = 0;
                obj.k_sw = 0;
                
                Co = ctrb(obj.A_tilde_ekf, obj.Qkalman);
                if rank(Co) == size(obj.A_tilde_ekf,1)
                    disp('EKF Fully controllable');
                else
                    disp('EKF Not fully controllable');
                end

                [P, L, G, report] = idare(obj.A_tilde_ekf', obj.C_ekf', obj.Qkalman, obj.Rkalman); 

                if report.Report == 0
                    disp('EKF seems stable.');
                end
            end
        end
    end
end












