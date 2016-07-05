%Final version 1.0
%This script is for analyzing data from a SciMeasure NDR camera
%The script brings up a dialog for selecting your file and will
%automatically detect the reset frame locations.
%
%Important variables for changing:
%   level - the value used to determine pixels of interest on an image
%   threshold - the value used to determine if a blink is present in the
%               trace
%
%Important outputs:
%   fits - locations of events, column 2 is the x value, column 4 is the y
%          value
%
%Example:
%   plot(fits(:,2),fits(:,4), '.')
%
%Authors: Dr Ashley Cadby and Sam Barnett
%Date: 29/06/2016
%%
%------------------ BEGIN CODE ----------------------

clear
%Open parallel pool if one isn't already open
if isempty(gcp('nocreate'))
    parpool('local', 2)
end

%Open file and retreive header information
[filename, Path] = uigetfile('*.tsm');
file = strcat(Path,filename);
fileInfo = NDR_FileInfo(file);

%initialise important variables
level=45;
cut_size = 5;
threshold = 35;
blink_store = [];
bounding_boxa = [];
frames_founda = [];
cut = [];
blinka=zeros((cut_size*2)+1,(cut_size*2)+1,1);

%Find the locations of the reset frames within the file
[chunk_pos fileInfo] = NDR_DefineResets( file, fileInfo );
disp(['Loaded in ', int2str(size(chunk_pos,1)), ' chunks'])
%%
%Monitor how far through the data
fprintf('Progress:\n');
fprintf(['\n' repmat('.',1,100) '\n\n']);
%Cropping to lower memory requirements
fileInfo.cwidth = 130;
fileInfo.cheight = 140;

parfor i = 5:size(chunk_pos,1)-1 %-1 because last chunk is also not a full chunk
    chunk = NDR_LoadData( file, chunk_pos(i,2), chunk_pos(i+1,2), fileInfo);
    %chunk = chunk(10:90,980:1100,:); %crop center, significantly reduces memory issues
    chunk = chunk(40:180, 170:300,:);
    
    [ blink{i},frames_found{i}, bounding_box{i} ] = NDR_gaussbin( chunk,fileInfo,level,cut_size,threshold,frames_founda,blinka,bounding_boxa,i);

    if rand < 100/size(chunk_pos,1)
        fprintf('\b|\n');
    end
end

%Unpack the events
blink_store = [];
num = 0;
string = strcat('Number of points unpacked: ', int2str(num));
fprintf(string)
for i = 1:size(blink,2)
    a = cell2mat(blink(i));
    for j = 2:size(a,3)
        blink_store(:,:,end+1) = a(:,:,j);
        num = num + 1;
        fprintf(repmat('\b',1,length(string)));
        string = strcat('Number of points unpacked: ', int2str(num));
        fprintf(string)
    end
end
fprintf('\n')
%first event is blank
blink_store = blink_store(:,:,2:end);
%unpack the region locations
bounding_boxa = [];
num2 = 0;
string = strcat('Number of points unpacked: ', int2str(num2));
fprintf(string)
for i = 1:size(blink,2)
    a = cell2mat(bounding_box(i));
    for j = 1:size(a,1)
        bounding_boxa(end+1,:) = a(j,:);
        num2 = num2+1;
        fprintf(repmat('\b',1,length(string)));
        string = strcat('Number of points unpacked: ', int2str(num2));
        fprintf(string)
    end
end
fprintf('\n')

%Fit events
fits = NDR_fit_stack(blink_store);
fits(:,2) = bounding_boxa(:,3) + fits(:,2);
fits(:,4) = bounding_boxa(:,1) + fits(:,4);
%Filter out false fits that are exactly on a pixel edge
fits(:,7) = mod(fits(:,4),1);
ind = find(fits(:,7) < 0.999 & fits(:,7) > 1e-05);
fits = fits(ind,:);
fits(:,7) = mod(fits(:,2),1);
ind = find(fits(:,7) < 0.999 & fits(:,7) > 1e-05);
fits = fits(ind,:);

