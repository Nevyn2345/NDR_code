%Final version 0.2
clear
%Open parallel pool if one isn't already open
if isempty(gcp('nocreate'))
    parpool('local', 2)
end
%%
[filename, Path] = uigetfile('*.tsm');
file = strcat(Path,filename);
fileInfo = NDR_FileInfo(file);
%%
level=40;
cut_size = 5;
threshold = 30;
blink_store = [];
bounding_boxa = [];
frames_founda = [];
cut = [];
blinka=zeros((cut_size*2)+1,(cut_size*2)+1,1);
%%
[chunk_pos fileInfo] = NDR_DefineResets( file, fileInfo ); % load beginning of file, find resets, returns list of reset locations
disp(['Loaded in ', int2str(size(chunk_pos,1)), ' chunks'])

%%
fprintf('Progress:\n');
fprintf(['\n' repmat('.',1,100) '\n\n']);
%This is the for loop
fileInfo.cwidth = 120;
fileInfo.cheight = 80;

for i = 1:size(chunk_pos,1)-1 %-1 because last chunk is also not a full chunk
    chunk = NDR_LoadData( file, chunk_pos(i,2), chunk_pos(i+1,2), fileInfo);
    chunk = chunk(10:90,980:1100,:); %crop center,plo significantly reduces memory issues
    %chunk = chunk(40:180, 170:300,:);
    
    [ blink{i},frames_found{i}, bounding_box{i} ] = NDR_gaussbin( chunk,fileInfo,level,cut_size,threshold,frames_founda,blinka,bounding_boxa,i);

    %[ blink{i},frames_found{i}, bounding_box{i},cleaned_image(:,:,i) ] = NDR_main_loop( chunk,fileInfo,level,cut_size,threshold,frames_founda,blinka,bounding_boxa,i);
    %fprintf(['\n','Processed chunk: ', int2str(size(blink,2)), '/',int2str(size(chunk_pos,1))]);
    if rand < 100/size(chunk_pos,1)
        fprintf('\b|\n');
    end
end
%Unpack the events

blink_store = [];
num = 0;
string = strcat('Number of points unpacked: ', int2str(num), '\n');
fprintf(string)
for i = 1:size(blink,2)
    a = cell2mat(blink(i));
    for j = 2:size(a,3)
        blink_store(:,:,end+1) = a(:,:,j);
        num = num + 1;
        fprintf(repmat('\b',1,length(string)-1));
        string = strcat('Number of points unpacked: ', int2str(num), '\n');
        fprintf(string)
    end
end
%first event is blank
blink_store = blink_store(:,:,2:end);
%unpack the region locations
bounding_boxa = [];
num2 = 0;
string = strcat('Number of points unpacked: ', int2str(num2), '\n');
fprintf(string)
for i = 1:size(blink,2)
    a = cell2mat(bounding_box(i));
    for j = 1:size(a,1)
        bounding_boxa(end+1,:) = a(j,:);
        num2 = num2+1;
        fprintf(repmat('\b',1,length(string)-1));
        string = strcat('Number of points unpacked: ', int2str(num2), '\n');
        fprintf(string)
    end
end

fits = NDR_fit_stack(blink_store);
fits(:,2) = bounding_boxa(:,3) + fits(:,2);
fits(:,4) = bounding_boxa(:,1) + fits(:,4);
%Filter out fits that are exactly on a pixel edge
fits(:,7) = mod(fits(:,4),1);
ind = find(fits(:,7) < 0.999 & fits(:,7) > 1e-05);
fits = fits(ind,:);
fits(:,7) = mod(fits(:,2),1);
ind = find(fits(:,7) < 0.999 & fits(:,7) > 1e-05);
fits = fits(ind,:);

