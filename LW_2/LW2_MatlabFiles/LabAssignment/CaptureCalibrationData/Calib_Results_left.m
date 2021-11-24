% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 357.933918144067889 ; 359.209303119385140 ];

%-- Principal point:
cc = [ 259.349149646152966 ; 208.967982271013199 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.088276762354986 ; -0.235998879746712 ; 0.001700321279805 ; 0.001644975102402 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 12.868734270915287 ; 12.915827809657731 ];

%-- Principal point uncertainty:
cc_error = [ 3.933442771185653 ; 3.171458006247443 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.022552001817966 ; 0.071064667914755 ; 0.002626258096465 ; 0.002751347944161 ; 0.000000000000000 ];

%-- Image size:
nx = 512;
ny = 424;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 12;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -2.242369e+00 ; -2.174966e+00 ; -2.089063e-02 ];
Tc_1  = [ -1.015980e+02 ; -4.463021e+01 ; 3.461186e+02 ];
omc_error_1 = [ 7.144790e-03 ; 8.202365e-03 ; 1.641077e-02 ];
Tc_error_1  = [ 3.809088e+00 ; 3.080391e+00 ; 1.246089e+01 ];

%-- Image #2:
omc_2 = [ -2.161175e+00 ; -2.121528e+00 ; 4.206768e-02 ];
Tc_2  = [ -1.183667e+02 ; -4.390904e+01 ; 3.422595e+02 ];
omc_error_2 = [ 7.381211e-03 ; 8.082026e-03 ; 1.451707e-02 ];
Tc_error_2  = [ 3.694696e+00 ; 3.042349e+00 ; 1.201633e+01 ];

%-- Image #3:
omc_3 = [ 2.214133e+00 ; 2.100676e+00 ; 2.119001e-01 ];
Tc_3  = [ -1.365792e+02 ; -3.694598e+01 ; 3.018879e+02 ];
omc_error_3 = [ 8.072781e-03 ; 6.673739e-03 ; 1.622412e-02 ];
Tc_error_3  = [ 3.403234e+00 ; 2.758718e+00 ; 1.090727e+01 ];

%-- Image #4:
omc_4 = [ 2.195622e+00 ; 2.128160e+00 ; -1.312689e-01 ];
Tc_4  = [ -1.227930e+02 ; -3.919082e+01 ; 3.425298e+02 ];
omc_error_4 = [ 8.010776e-03 ; 7.617503e-03 ; 1.604232e-02 ];
Tc_error_4  = [ 3.724037e+00 ; 3.010251e+00 ; 1.226996e+01 ];

%-- Image #5:
omc_5 = [ 2.144588e+00 ; 2.079453e+00 ; -2.281220e-01 ];
Tc_5  = [ -1.201321e+02 ; -3.394667e+01 ; 3.406937e+02 ];
omc_error_5 = [ 8.127928e-03 ; 8.197781e-03 ; 1.576251e-02 ];
Tc_error_5  = [ 3.663861e+00 ; 2.966727e+00 ; 1.192750e+01 ];

%-- Image #6:
omc_6 = [ -2.234444e+00 ; -2.170928e+00 ; -1.144146e-02 ];
Tc_6  = [ -1.175708e+02 ; -4.440525e+01 ; 3.459095e+02 ];
omc_error_6 = [ 7.247958e-03 ; 7.973263e-03 ; 1.598644e-02 ];
Tc_error_6  = [ 3.803390e+00 ; 3.086438e+00 ; 1.245590e+01 ];

%-- Image #7:
omc_7 = [ 2.232101e+00 ; 2.122043e+00 ; 3.597141e-01 ];
Tc_7  = [ -1.257379e+02 ; -3.544715e+01 ; 2.907536e+02 ];
omc_error_7 = [ 8.315862e-03 ; 5.788297e-03 ; 1.752976e-02 ];
Tc_error_7  = [ 3.274882e+00 ; 2.665765e+00 ; 1.059704e+01 ];

%-- Image #8:
omc_8 = [ -2.145748e+00 ; -2.093953e+00 ; -7.115462e-02 ];
Tc_8  = [ -1.323550e+02 ; -4.459287e+01 ; 3.462698e+02 ];
omc_error_8 = [ 7.521978e-03 ; 8.090169e-03 ; 1.453710e-02 ];
Tc_error_8  = [ 3.781076e+00 ; 3.114344e+00 ; 1.229409e+01 ];

%-- Image #9:
omc_9 = [ -2.253927e+00 ; -2.184138e+00 ; -3.486747e-02 ];
Tc_9  = [ -1.093280e+02 ; -4.434477e+01 ; 3.440048e+02 ];
omc_error_9 = [ 7.172621e-03 ; 8.047537e-03 ; 1.634778e-02 ];
Tc_error_9  = [ 3.798485e+00 ; 3.069269e+00 ; 1.242414e+01 ];

%-- Image #10:
omc_10 = [ 2.169262e+00 ; 2.028207e+00 ; 3.482265e-01 ];
Tc_10  = [ -1.195019e+02 ; -3.216431e+01 ; 2.698579e+02 ];
omc_error_10 = [ 8.800488e-03 ; 6.563624e-03 ; 1.709388e-02 ];
Tc_error_10  = [ 3.027423e+00 ; 2.472788e+00 ; 9.673436e+00 ];

%-- Image #11:
omc_11 = [ 2.208039e+00 ; 2.086891e+00 ; 2.676089e-01 ];
Tc_11  = [ -1.245110e+02 ; -3.583876e+01 ; 2.932888e+02 ];
omc_error_11 = [ 8.236132e-03 ; 6.351579e-03 ; 1.653536e-02 ];
Tc_error_11  = [ 3.301110e+00 ; 2.676430e+00 ; 1.058678e+01 ];

%-- Image #12:
omc_12 = [ 2.208578e+00 ; 2.087753e+00 ; 2.680527e-01 ];
Tc_12  = [ -1.245059e+02 ; -3.584054e+01 ; 2.932779e+02 ];
omc_error_12 = [ 8.231335e-03 ; 6.340126e-03 ; 1.654052e-02 ];
Tc_error_12  = [ 3.300960e+00 ; 2.676415e+00 ; 1.058777e+01 ];

