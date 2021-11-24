% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 1065.793094485789879 ; 1069.395482498376168 ];

%-- Principal point:
cc = [ 935.506806963069266 ; 525.262649680567051 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.031351258294299 ; -0.015486387705836 ; -0.000785829819455 ; -0.002287990759519 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 5.934811199632791 ; 5.965096139458561 ];

%-- Principal point uncertainty:
cc_error = [ 1.845465468231906 ; 1.322206740364268 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.002405070682829 ; 0.004768370080135 ; 0.000322783332521 ; 0.000481286444538 ; 0.000000000000000 ];

%-- Image size:
nx = 1920;
ny = 1080;


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
omc_1 = [ -2.249216e+00 ; -2.168575e+00 ; -1.398650e-02 ];
Tc_1  = [ -4.667596e+01 ; -4.146547e+01 ; 3.536306e+02 ];
omc_error_1 = [ 9.492668e-04 ; 1.254256e-03 ; 2.246570e-03 ];
Tc_error_1  = [ 6.145353e-01 ; 4.375942e-01 ; 1.964487e+00 ];

%-- Image #2:
omc_2 = [ -2.165242e+00 ; -2.114540e+00 ; 5.351305e-02 ];
Tc_2  = [ -6.331420e+01 ; -4.092142e+01 ; 3.500764e+02 ];
omc_error_2 = [ 1.071749e-03 ; 1.338739e-03 ; 2.135094e-03 ];
Tc_error_2  = [ 6.052676e-01 ; 4.313980e-01 ; 1.891527e+00 ];

%-- Image #3:
omc_3 = [ 2.222084e+00 ; 2.096503e+00 ; 1.964158e-01 ];
Tc_3  = [ -8.208761e+01 ; -3.388753e+01 ; 3.100853e+02 ];
omc_error_3 = [ 1.224219e-03 ; 8.730756e-04 ; 2.265765e-03 ];
Tc_error_3  = [ 5.465634e-01 ; 3.875474e-01 ; 1.729047e+00 ];

%-- Image #4:
omc_4 = [ 2.199329e+00 ; 2.120999e+00 ; -1.405222e-01 ];
Tc_4  = [ -6.783275e+01 ; -3.610772e+01 ; 3.498378e+02 ];
omc_error_4 = [ 1.252673e-03 ; 1.056647e-03 ; 2.251721e-03 ];
Tc_error_4  = [ 6.006797e-01 ; 4.268081e-01 ; 1.937180e+00 ];

%-- Image #5:
omc_5 = [ 2.147867e+00 ; 2.073474e+00 ; -2.387272e-01 ];
Tc_5  = [ -6.517858e+01 ; -3.087875e+01 ; 3.478045e+02 ];
omc_error_5 = [ 1.336743e-03 ; 1.242328e-03 ; 2.256037e-03 ];
Tc_error_5  = [ 5.918614e-01 ; 4.211624e-01 ; 1.875614e+00 ];

%-- Image #6:
omc_6 = [ -2.238233e+00 ; -2.162262e+00 ; -3.886963e-05 ];
Tc_6  = [ -6.271154e+01 ; -4.120034e+01 ; 3.540021e+02 ];
omc_error_6 = [ 9.782854e-04 ; 1.242040e-03 ; 2.261841e-03 ];
Tc_error_6  = [ 6.151254e-01 ; 4.380558e-01 ; 1.964345e+00 ];

%-- Image #7:
omc_7 = [ 2.235537e+00 ; 2.115387e+00 ; 3.508515e-01 ];
Tc_7  = [ -7.098393e+01 ; -3.260849e+01 ; 2.980033e+02 ];
omc_error_7 = [ 1.312857e-03 ; 7.808920e-04 ; 2.524954e-03 ];
Tc_error_7  = [ 5.234116e-01 ; 3.737511e-01 ; 1.679224e+00 ];

%-- Image #8:
omc_8 = [ -2.151887e+00 ; -2.086199e+00 ; -5.945178e-02 ];
Tc_8  = [ -7.750078e+01 ; -4.131277e+01 ; 3.546327e+02 ];
omc_error_8 = [ 1.089833e-03 ; 1.315086e-03 ; 2.259174e-03 ];
Tc_error_8  = [ 6.175624e-01 ; 4.408183e-01 ; 1.915622e+00 ];

%-- Image #9:
omc_9 = [ -2.256578e+00 ; -2.172465e+00 ; -2.200749e-02 ];
Tc_9  = [ -5.465653e+01 ; -4.112612e+01 ; 3.523987e+02 ];
omc_error_9 = [ 9.531705e-04 ; 1.235059e-03 ; 2.258829e-03 ];
Tc_error_9  = [ 6.130209e-01 ; 4.363394e-01 ; 1.960462e+00 ];

%-- Image #10:
omc_10 = [ 2.176872e+00 ; 2.024879e+00 ; 3.387251e-01 ];
Tc_10  = [ -6.518031e+01 ; -2.928695e+01 ; 2.769256e+02 ];
omc_error_10 = [ 1.363843e-03 ; 9.172521e-04 ; 2.398380e-03 ];
Tc_error_10  = [ 4.857634e-01 ; 3.461735e-01 ; 1.550062e+00 ];

%-- Image #11:
omc_11 = [ 2.214161e+00 ; 2.082065e+00 ; 2.555515e-01 ];
Tc_11  = [ -7.002935e+01 ; -3.299788e+01 ; 3.006867e+02 ];
omc_error_11 = [ 1.271147e-03 ; 8.543442e-04 ; 2.326086e-03 ];
Tc_error_11  = [ 5.285569e-01 ; 3.756851e-01 ; 1.679963e+00 ];

%-- Image #12:
omc_12 = [ 2.214217e+00 ; 2.082096e+00 ; 2.560445e-01 ];
Tc_12  = [ -7.002006e+01 ; -3.298439e+01 ; 3.006873e+02 ];
omc_error_12 = [ 1.271452e-03 ; 8.541115e-04 ; 2.327127e-03 ];
Tc_error_12  = [ 5.285548e-01 ; 3.756918e-01 ; 1.680032e+00 ];

