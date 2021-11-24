%%% INPUT THE IMAGE FILE NAME:

if ~exist('fc')|~exist('cc')|~exist('kc')|~exist('alpha_c'),
    fprintf(1,'No intrinsic camera parameters available.\n');
    return;
end;

KK = [fc(1) alpha_c*fc(1) cc(1);0 fc(2) cc(2) ; 0 0 1];

%%% Compute the new KK matrix to fit as much data in the image (in order to
%%% accomodate large distortions:
r2_extreme = (nx^2/(4*fc(1)^2) + ny^2/(4*fc(2)^2));
dist_amount = 1; %(1+kc(1)*r2_extreme + kc(2)*r2_extreme^2);
fc_new = dist_amount * fc;

KK_new = [fc_new(1) alpha_c*fc_new(1) cc(1);0 fc_new(2) cc(2) ; 0 0 1];

disp('Program that undistorts images');
disp('The intrinsic camera parameters are assumed to be known (previously computed)');

fprintf(1,'\n');

quest = input('Do you want to undistort all the calibration images ([],0) or a new image (1)? ');

if isempty(quest),
    quest = 0;
end;

if ~quest,
    
    if n_ima == 0,
        fprintf(1,'No image data available\n');
        return;
    end;
    
    if ~exist(['I_' num2str(ind_active(1))]),
        ima_read_calib;
    end;
    
    check_active_images;   
    
    format_image2 = format_image;
    if format_image2(1) == 'j',
        format_image2 = 'tif';
    end;
    
    for kk = 1:n_ima,
        
        if exist(['I_' num2str(kk)]),
            
            %Modified
            %eval(['I = I_' num2str(kk) ';']);
            %[I2] = rect(I,eye(3),fc,cc,kc,KK_new);
            
          
            if ~type_numbering,   
                number_ext =  num2str(image_numbers(kk));
            else
                number_ext = sprintf(['%.' num2str(N_slots) 'd'],image_numbers(kk));
            end;
            
            %Load image
            I = double(imread([calib_name number_ext '.' format_image2]));
            
            if(size(I,3) > 1)
                I2(:,:,1) = rect(I(:,:,1),eye(3),fc,cc,kc,KK_new);
                I2(:,:,2) = rect(I(:,:,2),eye(3),fc,cc,kc,KK_new);
                I2(:,:,3) = rect(I(:,:,3),eye(3),fc,cc,kc,KK_new);
                
            else
                I2 = rect(I,eye(3),fc,cc,kc,KK_new);
            end
            
            ima_name2 = [calib_name '_rect' number_ext '.' format_image2];
            
            fprintf(1,['Saving undistorted image under ' ima_name2 '...\n']);
            
            
            if format_image2(1) == 'p',
                if format_image2(2) == 'p',
                    saveppm(ima_name2,uint8(round(I2)));
                else
                    savepgm(ima_name2,uint8(round(I2)));
                end;
            else
                if format_image2(1) == 'r',
                    writeras(ima_name2,round(I2),gray(256));
                else
                    %Modified
                    %imwrite(uint8(round(I2)),gray(256),ima_name2,format_image2);
                    if(strcmp(origFmt,'uint16'))
                        imwrite(uint16(round(I2)),ima_name2,format_image2);
                    else
                        imwrite(uint8(round(I2)),ima_name2,format_image2);
                    end
                    
                end;
            end;
            
            
        end;
        
    end;
    
    fprintf(1,'done\n');
    
else
    
    dir;
    fprintf(1,'\n');
    
    image_name = input('Image name (full name without extension): ','s');
    
    format_image2 = '0';
    
    while format_image2 == '0',
        
        format_image2 =  input('Image format: ([]=''r''=''ras'', ''b''=''bmp'', ''t''=''tif'', ''p''=''pgm'', ''j''=''jpg'', ''m''=''ppm'') ','s');
        
        if isempty(format_image2),
            format_image2 = 'ras';
        end;
        
        if lower(format_image2(1)) == 'm',
            format_image2 = 'ppm';
        else
            if lower(format_image2(1)) == 'b',
                format_image2 = 'bmp';
            else
                if lower(format_image2(1)) == 't',
                    format_image2 = 'tif';
                else
                    if lower(format_image2(1)) == 'p',
                        format_image2 = 'pgm';
                    else
                        if lower(format_image2(1)) == 'j',
                            format_image2 = 'jpg';
                        else
                            if lower(format_image2(1)) == 'r',
                                format_image2 = 'ras';
                            else  
                                disp('Invalid image format');
                                format_image2 = '0'; % Ask for format once again
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    
    ima_name = [image_name '.' format_image2];
    
    
    %%% READ IN IMAGE:
    origFmt = [];
    if format_image2(1) == 'p',
        if format_image2(2) == 'p',
            I = double(loadppm(ima_name));
        else
            I = double(loadpgm(ima_name));
        end;
    else
        if format_image2(1) == 'r',
            I = readras(ima_name);
        else
            origFmt = class(imread(ima_name));
            I = double(imread(ima_name));
        end;
    end;
    
    
    if(size(I,3) > 1)
        I2(:,:,1) = rect(I(:,:,1),eye(3),fc,cc,kc,KK_new);
        I2(:,:,2) = rect(I(:,:,2),eye(3),fc,cc,kc,KK_new);
        I2(:,:,3) = rect(I(:,:,3),eye(3),fc,cc,kc,KK_new);
        
        if (size(I,1)>ny)|(size(I,2)>nx),
            I2 = I2(1:ny,1:nx,:);
        end;
    else
        I2 = rect(I,eye(3),fc,cc,kc,KK_new);
        
        if (size(I,1)>ny)|(size(I,2)>nx),
            I2 = I2(1:ny,1:nx);
        end;
    end
    
    
    %if size(I,3)>1,
    %    I = I(:,:,2);
    %end;
    
    
    %if (size(I,1)>ny)|(size(I,2)>nx),
    %    I = I(1:ny,1:nx);
    %end;
    
    
    %% SHOW THE ORIGINAL IMAGE:
    
    figure(2);
    if(strcmp(origFmt,'uint16'))
        imagesc(uint16(I));
    else
        imagesc(uint8(I));
    end
    %image(uint8(I));
    %colormap(gray(256));
    title('Original image (with distortion)');
    axis image;
    drawnow;
    
    
    %% UNDISTORT THE IMAGE:
    
    fprintf(1,'Computing the undistorted image...')
    
    %[I2] = rect(I,eye(3),fc,cc,kc,alpha_c,KK_new);
    
    fprintf(1,'done\n');
    
    figure(3);
    if(strcmp(origFmt,'uint16'))
        imagesc(uint16(I2));
    else
        imagesc(uint8(I2));
    end
    %colormap(gray(256));
    title('Undistorted image');
    axis image;
    drawnow;
    
    
    %% SAVE THE IMAGE IN FILE:
    
    ima_name2 = [image_name '_rect.' format_image2];
    
    fprintf(1,['Saving undistorted image under ' ima_name2 '...']);
    
    if format_image2(1) == 'p',
        if format_image2(2) == 'p',
            saveppm(ima_name2,uint8(round(I2)));
        else
            savepgm(ima_name2,uint8(round(I2)));
        end;
    else
        if format_image2(1) == 'r',
            writeras(ima_name2,round(I2),gray(256));
        else
            if(strcmp(origFmt,'uint16'))
                imwrite(uint16(round(I2)),ima_name2,format_image2);
            else
                imwrite(uint8(round(I2)),ima_name2,format_image2);
            end
        end;
    end;
    
    fprintf(1,'done\n');
    
end;
