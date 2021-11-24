if ~exist('Calib_Results.mat'),

    %%fprintf(1,'\nCalibration file Calib_Results.mat not found!\n');
    %%return;
    str = input('Name of the calibration file: ','s');
   
    [~,name,ext] = fileparts(str);
    if (isempty(ext))
        ext = '.mat';
    end
    if ~exist([name ext])
        fprintf(1,['\nCalibration file ' name ext ' not found!\n']);
        return;
    end
    
end;

fprintf(1,['\nLoading calibration results from ' name ext '\n']);

load([name ext])

fprintf(1,'done\n');
