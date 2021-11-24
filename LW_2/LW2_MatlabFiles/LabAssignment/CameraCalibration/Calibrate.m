%--------------------------------------------------------------------------
% COMP.SGN.320 3D and Virtual Reality 
% Calibration of Kinect v2
% 
% Calibration object info.:
%   - Square dimensions: 40 x 40 mm
%   - Number of inner squares: 4 (vertical) by 6 (horizontal)
%
%--------------------------------------------------------------------------
clear all; close all; clc;
%% Add calibration lib
addpath('./TOOLBOX_calib');
%% Run calibration for each camera sensor
calib_gui;

%% Run stereo calibration
stereo_gui;

%% Save calibration parameters in a file called KinectData.mat 
SaveParametersStruct();