%--------------------------------------------------------------------------
%   Kinect interface for Matlab v0.2
%   
%   .Kinect Get Data   
%
%   Author: Filipe Gama
%   Email: filipe.xavier@outlook.com
%--------------------------------------------------------------------------
%   Output data:
%        ___________________________________
%       | STREAM OPTION |       OUTPUT      |
%       |_______________|___________________|                   
%       | OPTION = 0    | Color             |   
%       | OPTION = 1    | Depth             |   
%       | OPTION = 2    | IR                |   
%       | OPTION = 3    | Color & Depth     |   
%       | OPTION = 4    | Color & IR        |   
%       | OPTION = 5    | Depth & IR        |   
%       | OPTION = 6    | Color & Depth & IR|   
%       | OPTION = 7    | Body Track        |   
%       | OPTION = 8    | Depth & Face Track|
%        -----------------------------------
%   How to use:
%   [ OUTPUT ] = KinectGetData( HANDLE )
%--------------------------------------------------------------------------