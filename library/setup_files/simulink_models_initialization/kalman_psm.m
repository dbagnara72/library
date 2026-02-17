

%% PSM paramerters
Rs_norm_ekf = psm.Rs_norm;
Lalpha_norm_ekf = psm.Lalpha_norm;
Lbeta_norm_ekf = psm.Lbeta_norm;
Rs_norm_ekf = psm.Rs_norm;



A1_tilde_ekf = [-Rs_norm_ekf/Lalpha_norm_ekf 0 0 0 0 0; 0 -Rs_norm_ekf/Lalpha_norm_ekf 0 0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; ...
    0 0 0 0 0 1; 0 0 0 0 0 0];

A2_tilde_ekf = [0 0 0 1/Lbeta_norm_ekf 0 0; 0 0 -1/Lbeta_norm_ekf 0 0 0; ...
    0 0 0 -1 0 0; 0 0 1 0 0 0;...
    0 0 0 0 0 0; 0 0 0 0 0 0];

A3_tilde_ekf = [0 0 0 0 0 0; 0 0 0 0 0 -1/Lbeta_norm_ekf; ...
    0 0 0 0 0 0; 0 0 0 0 0 1;...
    0 0 0 0 0 0; 0 0 0 0 0 0];

A4_tilde_ekf = [0 0 0 0 0 1/Lalpha_norm_ekf; 0 0 0 0 0 0; ...
    0 0 0 0 0 -1; 0 0 0 0 0 0;...
    0 0 0 0 0 0; 0 0 0 0 0 0];

B_tilde_ekf = [1/Lalpha_norm_ekf 0; 0 1/Lbeta_norm_ekf; 0 0; 0 0; 0 0; 0 0];

C_ekf = [1 0 0 0 0 0; 0 1 0 0 0 0];
Bd_ekf = B_tilde_ekf*ts_inv;

%% Kalman init
Qkalman = ts_inv * [Rs_norm_ekf/Lalpha_norm_ekf 0 0 0 0 0; 0 Rs_norm_ekf/Lbeta_norm_ekf 0 0 0 0; ...
    0 0 1 0 0 0;...
    0 0 0 1 0 0;...
    0 0 0 0 1 0;...
    0 0 0 0 0 1];
Rkalman = [2 0; 0 2];

k_kalman = 1;
k_dc = 1e-3;
k_sw = 1e-3;









