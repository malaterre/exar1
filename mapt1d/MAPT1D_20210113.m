%% Processing  MAP-T1D Data
% Jack Virostko
% 2021-01-13

%% =======================================================================
%  Load DICOM files
%  =======================================================================

DICOM_prompt = strcat('Select the following DICOM files ',...
'and Export Volumes using the following naming convention: ', ...
'\n t1w', ...
'\n t2w', ...
'\n dwi (Philips)', ...
'\n dwi, dwi2, dwi3, dwi4, dwi4, dwi5, dwi6 (Siemens)', ...
'\n b1map', ...
'\n deg20', ...
'\n deg16', ...
'\n deg12', ...
'\n deg8', ...
'\n deg4', ...
'\n fat (If available)', ...
'\n t2star (If available)',...
'\n qdixon (If available; Philips) \n');
fprintf(DICOM_prompt);

dicomBrowser;
pause;

% Remove singleton dimensions and convert to double format

t1w = double(squeeze(t1w));
t2w = double(squeeze(t2w));
b1map = double(squeeze(b1map));
deg20 = double(squeeze(deg20));
deg16 = double(squeeze(deg16));
deg12 = double(squeeze(deg12));
deg8 = double(squeeze(deg8));
deg4 = double(squeeze(deg4));
dwi = double(squeeze(dwi));

% Siemens stores separate b values as separate DICOM files
if exist('dwi2') == 1
    dwi2 = double(squeeze(dwi2));
    dwi3 = double(squeeze(dwi3));
    dwi4 = double(squeeze(dwi4));
    dwi5 = double(squeeze(dwi5));
    dwi6 = double(squeeze(dwi6));
    dwi7 = double(squeeze(dwi7));
    dwi(:,:,:,1) = dwi;
    dwi(:,:,:,2) = dwi2;
    dwi(:,:,:,3) = dwi3;
    dwi(:,:,:,4) = dwi4; 
    dwi(:,:,:,5) = dwi5;
    dwi(:,:,:,6) = dwi6; 
    dwi(:,:,:,7) = dwi7;
end
    
if exist('fat') == 1
    fat = double(squeeze(fat));
end

if exist('t2star') == 1
    t2star = double(squeeze(t2star));
end

if exist('qdixon') == 1
    qdixon = double(squeeze(qdixon));
end

%% =======================================================================
%  Select save directory and filename
%  =======================================================================

disp('Select the folder where you would like to save results:   ');
folder_name = uigetdir;
cd(folder_name);
save_filename = input('What would you like to name the results?  ','s')

%% =======================================================================
%  Reformat B1map
%  =======================================================================

% Remove zero elements
z = (b1map == 0);
b1map(z) = interp1(find(~z), b1map(~z), find(z), 'nearest', 'extrap');

if size(b1map,3) > size(deg20,3) % Philips B1 map includes other scans
    Data_B1 = b1map(:,:,size(b1map,3)/2+1:3*size(b1map,3)/4);
    B1_norm = mean(mean(mean((Data_B1))));
    Data_B1(isnan(Data_B1)) = B1_norm;
    Data_B1(isinf(Data_B1)) = B1_norm;
    Data_B1(Data_B1<=0) = B1_norm;
    % Resize B1 map to match multiflip angle data
    Data_B1 = imresize3(Data_B1,[size(deg20,1), size(deg20,2),size(deg20,3)]);
    FA_vec = Data_B1(:)/B1_norm;
else % Siemens B1 map stands alone
    Data_B1 = b1map;
    Data_B1(isnan(Data_B1)) = 800;
    Data_B1(isinf(Data_B1)) = 800;
    Data_B1(Data_B1<=0) = 800;
    % Resize B1 map to match multiflip angle data
    Data_B1 = imresize3(Data_B1,[size(deg20,1), size(deg20,2),size(deg20,3)]);
    FA_vec = Data_B1(:)/800;
end
%% =======================================================================
%  Draw/load pancreas ROI
%  =======================================================================

mask_type = input('Enter 1 to mask the image in Matlab. Enter 2 to load previously created mask:   ');

switch mask_type

case 1
vuOnePaneViewer(t1w);
vuOnePaneROIDrawer(t2w);
disp('Press any key after drawing ROI around pancreas');
pause;
mask = double(vuOnePaneROIDrawer_ROI_0.Data);

case 2
disp('Select the .mat file containing the pancreas mask');
uiopen
mask = double(matArray);

otherwise
error('Invalid entry')

end

pancreas_mask = logical(mask);

%% =======================================================================
%  Calculate Pancreas Volume
%  =======================================================================

% Read image resolution and slice thickeness
inplane_res_x = t2w_spatialDetails.PixelSpacings(1,1);
inplane_res_y = t2w_spatialDetails.PixelSpacings(1,2);

% ensure slices 1 & 2 do not cross z = 0 when calculating slice thicknesses
slice_thick = abs(min(abs(t2w_spatialDetails.PatientPositions(1,3)) + abs(t2w_spatialDetails.PatientPositions(2,3)), abs(t2w_spatialDetails.PatientPositions(1,3)) - abs(t2w_spatialDetails.PatientPositions(2,3))));

for i = 1:size(pancreas_mask,3)
    area_pancreas_slice(i) = nnz(pancreas_mask(:,:,i))*inplane_res_x*inplane_res_y;
end

% multiply sum of areas times slice spacing and divide by 1000 to convert
% from mm^3 to cm^3
volume_pancreas = (sum(area_pancreas_slice)*slice_thick)/1000;

%% =======================================================================
%  Calculate surface area to volume ratio
%  =======================================================================

N = size(pancreas_mask, 3);     % N is the number of slices 
area = zeros(N, 1);               % preallocate array of areas
perimeter = zeros(N, 1);          % prealloc    ate array of perimeters
SA_parts = zeros(N, 1);           % preallocate array to hold components of surface area
vol_parts = zeros(N, 1);          % preallocate array to hold components of volume
for i = 1 : N
    % calculate the area of the pancrea slices
    area(i) = nnz(pancreas_mask(:, :, i)) * inplane_res_x * inplane_res_y;
    
    % check that area is greater than 0
    if area(i) > 0
        % create a struct with the perimeter and assign that to the
        % perimeter array
        perimeter_slice = regionprops(pancreas_mask(:, :, i), 'Perimeter');
        perimeter(i) = perimeter_slice.Perimeter;
        % calculate the surface area contribution made by each slice
        SA_parts(i) = perimeter(i) * slice_thick / 1000;
    % count perimeter as 0 if area is not greater than 0
    else
        perimeter(i) = 0;
    end 
end

% determine the surface area
surface_area = sum(SA_parts);

% compute SA to volume ratio
SA_to_vol_ratio = surface_area / volume_pancreas;

%% =======================================================================
%  Calculate ADC
%  =======================================================================

b_val = [0, 20, 50, 70 100, 200, 800];

if exist('dwi2') == 1
    % Siemens b values previously combined
    dwi_slices = size(dwi,4);
    Data_DWI = dwi;
else
    % Philips combines b values into a single DICOM
    dwi_slices = size(dwi,3)/size(b_val,2);
    for i = 1:dwi_slices
        Data_DWI(:,:,i,1) = dwi(:,:,(i-1)*size(b_val,2)+1);
        Data_DWI(:,:,i,2) = dwi(:,:,(i-1)*size(b_val,2)+2);
        Data_DWI(:,:,i,3) = dwi(:,:,(i-1)*size(b_val,2)+3);
        Data_DWI(:,:,i,4) = dwi(:,:,(i-1)*size(b_val,2)+4);
        Data_DWI(:,:,i,5) = dwi(:,:,(i-1)*size(b_val,2)+5);
        Data_DWI(:,:,i,6) = dwi(:,:,(i-1)*size(b_val,2)+6);
        Data_DWI(:,:,i,7) = dwi(:,:,(i-1)*size(b_val,2)+7);
    end
end

adc = (log(Data_DWI(:,:,:,7)) - log(Data_DWI(:,:,:,6)))./ (b_val(6) - b_val(7));

% adc filters
adc(isinf(adc))=0;
adc(isnan(adc))=0;
adc(adc < 0) = 0;

%% =======================================================================
%  Calculate fat fraction and T2 star maps 
%  =======================================================================
if exist('fat') == 1
    % in Siemens derived maps, fat fraction map indes value of 1000 is 100% fat
    fat = fat./1000;
end
if exist('t2star') == 1
    % in Siemens derived maps, T2 star map index value of 1 is 0.1 ms
    t2star = t2star.*0.1; % in units of [ms]
    % T2star filters
    t2star(t2star > 300) = 0;
end
if exist('qdixon') == 1 % Philips format
    % fat fraction map is 26th of 29 image sets in qdixon
    num_Dixon_slices = size(qdixon,3)/29; 
    fat = qdixon(:,:,num_Dixon_slices*26+1:num_Dixon_slices*26+1*num_Dixon_slices);
    fat_baseline=mode(mode(mode(fat(10:40,10:40,10:40)))); 
    fat = (fat-fat_baseline)/fat_baseline;
    fat(fat<0)=0;
    fat(fat>1)=1;
    % R2star map is 29th of 29 image sets in qdixon; invert for T2star
    R2star = qdixon(:,:,num_Dixon_slices*28+1:num_Dixon_slices*28+1*num_Dixon_slices);
    t2star = 1./R2star;
    t2star(isinf(t2star))=0;
    t2star(isnan(t2star))=0;
    t2star(t2star < 0) = 0;
    t2star = t2star.*1000; % convert to [ms]
    % T2star filters
    t2star(t2star > 300) = 0;
end

%% =======================================================================
%  Apply pancreas mask to parametric maps
%  =======================================================================

% Determine whether mask is flipped in axial plane
figure;
subplot(2,2,1),imagesc(t2w(:,:,size(t2w,3)/3));
subplot(2,2,2),imagesc(mask(:,:,size(t2w,3)/3)),ylabel('Not Flipped');
subplot(2,2,3),imagesc(t2w(:,:,size(t2w,3)/3));
subplot(2,2,4),imagesc(mask(:,:,2*size(t2w,3)/3+1)),ylabel('Flipped');

prompt = 'Does the mask need to be flipped (z axis) to match image orientation? Enter 0 for no (top), 1 for yes (bottom) ';
flip_query = input(prompt);
if flip_query == 1
    mask = flip(mask,3);
end

% Resize/pad parametric maps as needed

% DWI mask. Pre-test DWI and truncate Siemens mask
temp = unique(dwi_spatialDetails.PatientPositions(:,3));
scale_plane = t2w_spatialDetails.PixelSpacings(1)/dwi_spatialDetails.PixelSpacings(1);
scale_slice = abs(min(abs(t2w_spatialDetails.PatientPositions(1,3)) + abs(t2w_spatialDetails.PatientPositions(2,3)), abs(t2w_spatialDetails.PatientPositions(1,3)) - abs(t2w_spatialDetails.PatientPositions(2,3))))...
        /abs(min(abs(temp(1)) + abs(temp(2)), abs(temp(1)) - abs(temp(2))));

if size(mask,3) == uint64(size(adc,3)/scale_slice)
    mask_dwi = mask;
    mask_dwi = imresize3(mask,'Scale', [scale_plane scale_plane 1],'Method','Nearest');
    dwi_trunc = (size(mask,3)-size(adc,3))/2;
    mask_dwi(:,:,1:dwi_trunc)=[];
    mask_dwi(:,:,((size(mask_dwi,3)+1-dwi_trunc):end))=[];
else
    scale_plane = t2w_spatialDetails.PixelSpacings(1)/dwi_spatialDetails.PixelSpacings(1);
    % DWI repeats slices on Siemens & Philips
    temp = unique(dwi_spatialDetails.PatientPositions(:,3));
    scale_slice = abs(min(abs(t2w_spatialDetails.PatientPositions(1,3)) + abs(t2w_spatialDetails.PatientPositions(2,3)), abs(t2w_spatialDetails.PatientPositions(1,3)) - abs(t2w_spatialDetails.PatientPositions(2,3))))...
        /abs(min(abs(temp(1)) + abs(temp(2)), abs(temp(1)) - abs(temp(2))));
    mask_dwi = imresize3(mask,'Scale', [scale_plane scale_plane scale_slice],'Method','Nearest');
    if any(size(mask_dwi) < size(adc))
            mask_dwi = padarray(mask_dwi, floor((size(adc)-size(mask_dwi))/2));
            if any(rem(size(adc)-size(mask_dwi),2))
                mask_dwi = padarray(mask_dwi, size(adc)-size(mask_dwi),'post');
            end
    end  
end
if dwi_spatialDetails.PatientPositions((round(size(dwi_spatialDetails.PatientPositions,1)/2)),3) ~= t2w_spatialDetails.PatientPositions((size(t2w_spatialDetails.PatientPositions,1)/2),3)
    mask_dwi = circshift(mask_dwi,[0 0 scale_slice*round((t2w_spatialDetails.PatientPositions((size(t2w_spatialDetails.PatientPositions,1)/2),3)-dwi_spatialDetails.PatientPositions((round(size(dwi_spatialDetails.PatientPositions,1)/2)),3))/slice_thick)]);
end

% T1 mask
scale_plane = t2w_spatialDetails.PixelSpacings(1)/deg20_spatialDetails.PixelSpacings(1);
scale_slice = abs(min(abs(t2w_spatialDetails.PatientPositions(1,3)) + abs(t2w_spatialDetails.PatientPositions(2,3)), abs(t2w_spatialDetails.PatientPositions(1,3)) - abs(t2w_spatialDetails.PatientPositions(2,3))))...
        /abs(min(abs(deg20_spatialDetails.PatientPositions(1,3)) + abs(deg20_spatialDetails.PatientPositions(2,3)), abs(deg20_spatialDetails.PatientPositions(1,3)) - abs(deg20_spatialDetails.PatientPositions(2,3))));
mask_T1 = imresize3(mask,'Scale', [scale_plane scale_plane scale_slice],'Method','Nearest');
if any(size(mask_T1) ~= size(deg20))
    mask_T1 = padarray(mask_T1, floor((size(deg20)-size(mask_T1))/2));
    if any(rem(size(deg20)-size(mask_T1),2))
        mask_T1 = padarray(mask_T1, size(deg20)-size(mask_T1),'post');
    end
end   
if deg20_spatialDetails.PatientPositions((size(deg20_spatialDetails.PatientPositions,1)/2),3) ~= t2w_spatialDetails.PatientPositions((size(t2w_spatialDetails.PatientPositions,1)/2),3)
    mask_T1 = circshift(mask_T1,[0 0 scale_slice*round((t2w_spatialDetails.PatientPositions((size(t2w_spatialDetails.PatientPositions,1)/2),3)-deg20_spatialDetails.PatientPositions((size(deg20_spatialDetails.PatientPositions,1)/2),3))/slice_thick)]);
end

% qDixon mask
if exist('qdixon') == 1
    fat_spatialDetails.PixelSpacings=qdixon_spatialDetails.PixelSpacings;
    [~,b]=unique(qdixon_spatialDetails.PatientPositions(:,3),'stable');
    fat_spatialDetails.PatientPositions=qdixon_spatialDetails.PatientPositions(b,:);
end

% fat mask
if exist('fat') == 1
    scale_plane = t2w_spatialDetails.PixelSpacings(1)/fat_spatialDetails.PixelSpacings(1);
    scale_slice = abs(min(abs(t2w_spatialDetails.PatientPositions(1,3)) + abs(t2w_spatialDetails.PatientPositions(2,3)), abs(t2w_spatialDetails.PatientPositions(1,3)) - abs(t2w_spatialDetails.PatientPositions(2,3))))...
        /abs(min(abs(fat_spatialDetails.PatientPositions(1,3)) + abs(fat_spatialDetails.PatientPositions(2,3)), abs(fat_spatialDetails.PatientPositions(1,3)) - abs(fat_spatialDetails.PatientPositions(2,3))));
    mask_fat = imresize3(mask,'Scale', [scale_plane scale_plane scale_slice],'Method','Nearest');
    if any(size(mask_fat) ~= size(deg20))
        mask_fat = padarray(mask_fat, floor((size(fat)-size(mask_fat))/2));
        if any(rem(size(fat)-size(mask_fat),2))
            mask_fat = padarray(mask_fat, size(fat)-size(mask_fat),'post');
        end
    end   
    if fat_spatialDetails.PatientPositions((round(size(fat_spatialDetails.PatientPositions,1)/2)),3) ~= t2w_spatialDetails.PatientPositions((size(t2w_spatialDetails.PatientPositions,1)/2),3)
        mask_fat = padarray(mask_fat, size(fat)-size(mask_fat),'post');
         end
end

% t2star mask
if exist('t2star') == 1
    mask_T2star = mask_fat;
end

%% =======================================================================
%  Calculate T1
%  =======================================================================

%FA needs to be in degrees
%TR in ms
%assumes data is arranged in a matrix that is # of voxels by # of FA, where
%each row is the SI for a single voxel at each FA

% TR in units of [ms]
% TR = double(twen_deg_header.Private_2005_1030(1));
TR = 4.6;

numvox = size(deg20,1) * size(deg20,2) * size(deg20,3);
FA = [20, 16, 12, 8, 4];
numFA = size(FA,2);

%%%% CREATE VECTORIZED DATA %%%%%
Data_T1(:,:,:,1) =  deg20;
Data_T1(:,:,:,2) =  deg16;
Data_T1(:,:,:,3) =  deg12;
Data_T1(:,:,:,4) =  deg8;
Data_T1(:,:,:,5) =  deg4;

voxdata=zeros(numvox,numFA);
for i=1:numFA
    temp=Data_T1(:,:,:,i);
    temp=temp(:);
    voxdata(:,i)=temp;
    clear temp;
end
 
%%%% COMMON FACTOR FOR S0 ESTIMATION, from gradient echo equation %%%%%%%
T1_init=mean(FA);
A1_fact=(1-cosd(mean(FA))*exp(-TR/T1_init))/(sind(mean(FA))*(1-exp(-TR/T1_init)));

%%%% OPTIMIZATION OPTIONS %%%%%%%
%turn output (display) to off
options=statset('Display','off');
%turn off warnings - need to do on all workers
warning('off','all')
%preallocate t1 map and s0 map
x=zeros(numvox,2);
%%%%  LOOP THROUGH ALL VOXELS  %%%%%%
fprintf('Total number of voxels is %i \n',numvox);

fprintf('Starting T1 mapping (MFA all slices) .... \n');
tic
parfor i=1:numvox
    test=voxdata(i,:);
    guesses = [mean(test)*A1_fact T1_init];
    % B1 correction
    FA_vox=FA_vec(i)*FA;
%     % no B1 correction
%     FA_vox = FA;
    if max(test)>7 && numel(find(test>5))>round(numel(test)/2)
        %%%%  OPTIMIZE FOR T1 %%%%%%%%
        [x(i,:),~]=lsqcurvefit('MF_T1_map',guesses,FA_vox,test,[],[],options,TR);

    else
        x(i,:)=[-1 -1];
    end
end
tt = toc;
fprintf('T1 MFA mapping done. Total time =  %10.2f s.\n',tt);
        
x(x(:,1)<0,:)=0; x(x(:,2)<0,:)=0;

%%%%%  RESHAPE MAPS TO ORIGINAL SIZE %%%%%%%%%
T1_map=reshape(x(:,2),[size(deg20,1) size(deg20,2) size(deg20,3)]);
S0_map=reshape(x(:,1),[size(deg20,1) size(deg20,2) size(deg20,3)]);

% T1 filters
T1_map(T1_map> 2500) = 0;

%% Apply pancreas ROI to parametric maps

pancreas_adc = adc.*mask_dwi;
pancreas_T1 = T1_map.*mask_T1;
if exist('fat') == 1
    pancreas_fat = fat.*mask_fat;
end
if exist('t2star') == 1
    pancreas_t2star = t2star.*mask_fat;
end


%% =======================================================================
%  Calculate mean parameter values in pancreas ROI
%  =======================================================================

% ADC (exclude voxels with adc of 0)
mean_adc_pancreas = mean(pancreas_adc(logical(pancreas_adc)));
std_adc_pancreas = std(pancreas_adc(logical(pancreas_adc)));

% T1 (exclude voxels with T1 of 0)
mean_T1_pancreas = mean(pancreas_T1(logical(pancreas_T1)));
std_T1_pancreas = std(pancreas_T1(logical(pancreas_T1)));

% Fat fraction (include voxels with ff = 0)
if exist('fat') == 1
    mean_ff_pancreas = mean(pancreas_fat(logical(mask_fat)));
    std_ff_pancreas = std(pancreas_fat(logical(mask_fat)));
end

% T2star (include voxels with T2star of 0)
if exist('t2star') == 1
    mean_T2star_pancreas = mean(pancreas_t2star(logical(pancreas_t2star)));
    std_T2star_pancreas = std(pancreas_t2star(logical(pancreas_t2star)));
end

%% =======================================================================
%  Plot histograms of pancreas parameters
%  =======================================================================

figure; histogram(pancreas_adc(logical(pancreas_adc)));
title('Histogram of pancreas ADC values');

figure; histogram(pancreas_T1(logical(pancreas_T1)));
title('Histogram of pancreas T1 values');

if exist('fat') == 1
    figure; histogram(pancreas_fat(logical(pancreas_fat)));
    title('Histogram of pancreas fat fraction values');
end

if exist('t2star') == 1
    figure; histogram(pancreas_t2star(logical(pancreas_t2star)));
    title('Histogram of pancreas T2star values');
end

%% =======================================================================
%  Save data
%  =======================================================================

% Save .mat files
process_date = date;
save(strcat(save_filename, '_','Processed_',process_date));

% Save .txt file with summary stats

fid = fopen(strcat(save_filename, '_','Processed_',process_date,'_results.txt'), 'w');
fprintf(fid, 'Pancreas volume [ml]: %f \n', volume_pancreas);
if(exist('mean_adc_pancreas')) 
    fprintf(fid, 'Pancreas ADC measurement: : %f \n', mean_adc_pancreas);
    fprintf(fid, 'Pancreas ADC Standard Deviation: %f \n', std_adc_pancreas);
end
if(exist('mean_T1_pancreas')) 
    fprintf(fid, 'Pancreas T1 measurement: : %f \n', mean_T1_pancreas);
    fprintf(fid, 'Pancreas T1 Standard Deviation: %f \n', std_T1_pancreas);
end
if(exist('mean_ff_pancreas')) 
    fprintf(fid, 'Pancreas fat fraction measurement: : %f \n', mean_ff_pancreas);
    fprintf(fid, 'Pancreas fat fraction Standard Deviation: %f \n', std_ff_pancreas);
end
if(exist('mean_T2star_pancreas')) 
    fprintf(fid, 'Pancreas T2star measurement: : %f \n', mean_T2star_pancreas);
    fprintf(fid, 'Pancreas T2star Standard Deviation: %f \n', std_T2star_pancreas);
end
fprintf(fid, 'Pancreas surface area to volume ratio [cm-1]: %f \n', SA_to_vol_ratio);

% Save summary data in CSV file for import into REDCap
if exist('fat') == 1
    csvwrite(strcat(save_filename, '_','Processed_',process_date,'.csv'),[volume_pancreas,mean_adc_pancreas,std_adc_pancreas,...
    SA_to_vol_ratio,mean_T1_pancreas,std_T1_pancreas,mean_ff_pancreas,std_ff_pancreas,mean_T2star_pancreas,std_T2star_pancreas,vol_box, perc_box, perc_hull, principal_axis_lengths]);
else
    csvwrite(strcat(save_filename, '_','Processed_',process_date,'.csv'),[volume_pancreas,mean_adc_pancreas,std_adc_pancreas,...
    SA_to_vol_ratio,mean_T1_pancreas,std_T1_pancreas,vol_box, perc_box, perc_hull, principal_axis_lengths]);
end

%% Save DICOM mask
cd ../
cd DICOM
dicom_folder=pwd;

S = dir(fullfile(dicom_folder,'*.DCM'));
N = {S.name};
X = contains(N,'T2W_SPAIR');
dicom_mask = (fullfile(N{find(X,1,'last')}));

% Read in DICOM header from DICOM file used to generate mask
metadata = dicominfo(dicom_mask);
% Change DICOM header for output
metadata.SeriesDescription = 'mask';
% Make sure DICOM filesize matches mask size
if metadata.Rows ~= size(mask,1) | metadata.Columns ~= size(mask,2) | metadata.NumberOfFrames ~= size(mask,3)
    error('Dimension Mismatch')
end

% Reformat 
mask_dcm = im2uint16(mask);
mask_dcm = reshape(mask_dcm,[size(mask,1),size(mask,2),1,size(mask,3)]);
dicomwrite(mask_dcm, append(save_filename,'_mask.dcm'), metadata,'CreateMode', 'copy');
