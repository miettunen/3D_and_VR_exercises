%--------------------------------------------------------------------------
% COMP.SGN.320 3D and Virtual Reality 
% Calibration of Kinect v2
%--------------------------------------------------------------------------
function SaveParametersStruct()

%Get parameters from the stereo file
if(~exist('Calib_Results_stereo.mat'))
  
    warning(['The stereo calibration file with the name' ...
           ' ''Calib_Results_stereo.mat'' does not exist in' ...
           ' the current directory!!\n']);
    return;
end

load('Calib_Results_stereo.mat');

%Save 2D camera calibration
Cparam.cx = cc_right(1);
Cparam.cy = cc_right(2);
Cparam.fx = fc_right(1);
Cparam.fy = fc_right(2);
Cparam.RadialDist = [kc_right(1), kc_right(2), kc_right(5)];
Cparam.TangentialDist = [kc_right(3), kc_right(4)];

%Save range sensor calibration
Dparam.cx = cc_left(1);
Dparam.cy = cc_left(2);
Dparam.fx = fc_left(1);
Dparam.fy = fc_left(2);
Dparam.RadialDist = [kc_left(1), kc_left(2), kc_left(5)];
Dparam.TangentialDist = [kc_left(3), kc_left(4)];

%Save stereo parameters
R = R;

T = T;

save('KinectData.mat', 'Cparam', 'Dparam', 'T', 'R');

end

