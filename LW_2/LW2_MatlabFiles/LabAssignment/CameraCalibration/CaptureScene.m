%--------------------------------------------------------------------------
% COMP.SGN.320 3D and Virtual Reality 
% Capture Color + Depth data from Kinect v2 
%
% Kinect stream options:
%   Option 0 --> Colour                 
%   Option 1 --> Depth                  
%   Option 2 --> IR                     
%   Option 3 --> Colour & Depth        
%   Option 4 --> Colour & IR           
%   Option 5 --> Depth & IR            
%   Option 6 --> Colour & Depth & IR    
%   Option 7 --> Body Track             
%   Option 8 --> Depth & Face Track 
%--------------------------------------------------------------------------
clear all; close all; clc;
%% Add Kinect lib and calibration lib
addpath('./../CaptureCalibrationData/KinectLib/');
addpath('./TOOLBOX_calib');
%% Program parameters
outputImageFormat = 'tif';  %Format of the output image file. 
                            %Uncompressed and 16-bit support
%% Capture a new scene (color image + depth image) by pressing 's'
streamOption = 3;

%Initialize Kinect
kinectObj = KinectInterface(streamOption);
kinectObj = kinectObj.KinectInit();

%Grab data from Kinect
h = figure(1);
%Setup keyboard I/O
set(h,'WindowKeyPressFcn',@keyPressCallback);
key = [];
key.grabFrame = false;
key.exitLoop = false;
h.UserData = key;

%% 
I = imread('Depth.tif');
imshow(I,[0 1000])
%% 

while (ishandle(h))
    
    %Get data
    kinectObj = kinectObj.KinectGetData();
    colorFrame = kinectObj.colourImg;
    depthFrame = kinectObj.depthImg;
    
    
    if(~isempty(colorFrame) && ~isempty(depthFrame))
        %Show data
        subplot(121)
        imagesc(colorFrame);
        axis image;
        
        subplot(122)
        imagesc(depthFrame);
        colormap gray; 
        cb = colorbar;
        cb.FontSize = 20;
        axis image; 
        
        drawnow();
    end
    
    %Process I/O
    if(ishandle(h))
        key = h.UserData;
        figure(h); %Keep figure focus
    end
    if(key.grabFrame)
        
        %Wait for the next valid frame
        if(~isempty(colorFrame) && ~isempty(depthFrame))
            
            %Save image(s)
            colorTxt = sprintf(['./Colour.' outputImageFormat]);
            depthTxt = sprintf(['./Depth.' outputImageFormat]);
            
            imwrite(colorFrame,colorTxt);
            imwrite(depthFrame,depthTxt);
            
            %Reset save image trigger
            disp("Saving image...");
            key.grabFrame = false;
            h.UserData = key;
        end
    end
    
    if(key.exitLoop)
        break;
    end
    
end

%% Close Kinect and free memory
kinectObj.KinectClose();
clear mex;

%% Functions
%--------------------------------------------------------------------------
function keyPressCallback(source,eventdata)

%Determine the key that was pressed
keyPressed = eventdata.Key;

%If "s", save image
if(strcmp(keyPressed, 's'))
    key = source.UserData;
    key.grabFrame = true;
    source.UserData = key;
%If "q", quit loop
elseif(strcmp(keyPressed, 'q') || strcmp(keyPressed, 'escape'))
    key = source.UserData;
    key.exitLoop = true;
    source.UserData = key;
end

end
%%




