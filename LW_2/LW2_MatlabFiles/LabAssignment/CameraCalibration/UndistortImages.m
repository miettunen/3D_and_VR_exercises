%--------------------------------------------------------------------------
% COMP.SGN.320 3D and Virtual Reality 
% Undistort Kinect v2 images Color + Depth
%--------------------------------------------------------------------------
clear all; close all; clc;
%% Add calibration lib
addpath('./TOOLBOX_calib');
%% Undistort color images
clear; 
fprintf('Undistort colour image(s)');
%Load color calibration data
loading_calib;

%Undistort depth image
undistort_image;

%% Undistort IR/depth images
fprintf('Undistort IR/depth image(s)');
%Load IR calibration data
loading_calib;

%Undistort color image
undistort_image;