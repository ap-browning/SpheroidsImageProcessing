%% PROCESS CONFOCAL SPHEROID IMAGES
%  Instructions:
%   1. Run script and select folder containing adjusted tif images.
%       - Images must be output from "AdjustRawImages.mlapp" with 4
%           channels:
%           (1) DAPI (not used)
%           (2) Green
%           (3) Red
%           (4) Far Red (not used)
%       - File names are of the form, which correspond to the variables
%            ExpK_983b_RM_J_D16_1250_2.tif
%              |   |   |  |  |   |   |
%             (1) (2) (3)(4)(5) (6) (7)
%
%           (1) ExpID
%           (2) CellLine
%           (3) Plate
%           (4) MountingSolution
%           (5) Day
%           (6) InitialCondition
%           (7) Replicate
%   2. Script will process each image.
%   3. Follow the prompt to confirm processing of each image:
%       - Click "y" then "Enter"/"Return" (or just "Enter"/"Return") to
%         keep processed data from image.
%       - Click "n" then "Enter"/"Return" to reject data from image.
%   4. Enter file name to save data file to; or, type "n" and "Enter".
%   5. Enter folder to save processed images to; or, type "n" and "Enter".
%
% Note that images displayed and saved have the contrast boosted for
% clarity: what is displayed is not the raw data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SETTINGS

clear global

cycling_threshold = 0.2;
review_layout     = 'horizontal'; % or 'horizontal'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROCESS

% Get directory and list of files to process
directory = uigetdir();
addpath(directory);
addpath('functions');
files = filterfiles(dir(directory),'tif');

% Convert file list to data struct
data = fname2meta(files);

% Waitbar
textprogressbar('Processing images...  ');

% Loop through all files
for i = 1:length(data)
    
    textprogressbar(100 * i / length(data));

    % Load file and make composite image
    [raw,meta] = tifread(data(i).fname,directory);
    img = raw2img(raw,[1,1,0]);
    
    % Get masks
    [msk,cvx,innermsk,innercvx] = raw2msks(raw);
    
    % Get green pixel intensity distribution
    [I,R,D] = intensitydist(raw(:,:,2),cvx,'Scale',meta.Resolution,'Clip',0.1,'Mask',msk);
    
    % Fit Gompertz curve to pixel intesity distribution
    [p,fun] = intensitydistfit(R,I);
    
    % Summarise Gompertz curve to get distance from the periphary
    periph  = intensitysummary(p,max(D,[],'all'),cycling_threshold);

    % Create "smooth intesity image" to plot cycling boundary
    img_gn  = intensityimg(fun,D);
    
    % Save raw measurements
    data(i).SpheroidArea    = nnz(cvx) / meta.Resolution^2;
    data(i).NecroticArea    = nnz(innermsk) / meta.Resolution^2;
    data(i).GreenPeriphary  = periph;
    
    % Calculate summary statistics
    data(i).OuterRadius     = sqrt(data(i).SpheroidArea / pi);
    data(i).InhibitedRadius = max(0,data(i).OuterRadius - periph);
    data(i).NecroticRadius  = sqrt(data(i).NecroticArea / pi);
    data(i).InhibitedRadius = max(data(i).InhibitedRadius,data(i).NecroticRadius);
    data(i).ImageDate       = meta.CreationDate;
    data(i).ProcessDate     = datetime('now');
    
    % Store directory processed
    dir_info = split(directory,filesep);
    data(i).Directory       = join([dir_info{end-1},"/",dir_info{end}],"");
    
    % Save cycling region distribution parameters
    data(i).CyclingParams   = p;
    data(i).Dmax            = max(D,[],'all');
        
    % Data to store temporarily
    data(i).Result = imboundaries(img,{cvx,img_gn > fun(0) * cycling_threshold,innermsk});
    data(i).I      = I;
    data(i).R      = R;
    data(i).fun    = fun;
    
end

textprogressbar(' Processing Finished. Please Review.');

%% REVIEW
for i = 1:length(data)
    
    % Plot image and intensity distribution
    if strcmp(review_layout,'vertical')
        nr = 2; nc = 1;
    else
        nr = 1; nc = 2;
    end
    subplot(nr,nc,1); cla();
    imshow(data(i).Result);
    title(sprintf("%d/%d: %s",i,length(data),data(i).fname), 'Interpreter', 'none');
    subplot(nr,nc,2); cla();
    plot(data(i).R,data(i).I,'LineWidth',2); hold on;
    plot(data(i).R,data(i).fun(data(i).R),'LineWidth',2);
              
    keep = input(sprintf("Keep (%d/%d) %s: ",i,length(data),data(i).fname),"s");
    data(i).Keep = isempty(keep) || strcmp(keep,"y") || strcmp(keep,"Y");

end

%% SAVE DATA?
savedata = input("Save data? (filename | n):     ","s");
filter   = input("Filter data? (y | n):          ","s");
if ~strcmp(savedata,"n")
    if ~strcmp(filter,"n")
        writetable(struct2table(rmfield(filterdata(data),{'Result','I','R','fun'})),sprintf("%s.csv",savedata))
    else
        writetable(struct2table(rmfield(data,{'Result','I','R','fun'})),sprintf("%s.csv",savedata))
    end
end

% Write unfiltered CSV (timestamped) to parent directory
writetable(struct2table(rmfield(data,{'Result','I','R','fun'})),sprintf("%s/../Processed-%s.csv",directory,datetime('now','Format','yyyy-MM-dd_HH-mm-ss')));

%% SAVE IMAGES?
saveimgs = input("Save images? (folder | n):     ","s");
if ~strcmp(saveimgs,"n")
    mkdir(directory,saveimgs);
    for i = 1:length(data)
        imwrite(data(i).Result,sprintf("%s/%s/%s_%d.png",directory,saveimgs,data(i).fname,i));
    end
end