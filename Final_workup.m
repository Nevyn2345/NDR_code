%Final version 0.1
clear

[filename, Path] = uigetfile('*.tsm');
file = strcat(Path,filename);
fileInfo = NDR_FileInfo(file);

level=30;
cut_size = 5;
threshold = 35;
blink_store = [];
bounding_box = [];
frames_found = [];
cut = [];
blink=zeros((cut_size*2)+1,(cut_size*2)+1,1);

[chunk_pos] = NDR_DefineResets( file, fileInfo ); % load beginning of file, find resets, returns list of reset locations
disp(['Loaded in ', int2str(size(chunk_pos,1)), ' chunks'])

for i = 1:1%size(chunk_pos,1)-1 %-1 because last chunk is also not a full chunk
    disp(['Processing chunk: ', int2str(i), '/',int2str(size(chunk_pos,1))]);
    chunk = NDR_LoadData( file, chunk_pos(i,2), chunk_pos(i+1,2), fileInfo);
 %   [chunk ] = NDR_normalising( chunk );
    stout = NDR_STDDEV( chunk, fileInfo );
    [ cleaned_image ] = NDR_Select_points( stout, 1, 4 );
    [ holdall ] = NDR_select_possible_events( cleaned_image, level, i);
    
    if size(holdall,1) > 0
        holdall(:,4) = 1;
        for f = 1:size(holdall,1)
            if holdall(f,1) + cut_size > fileInfo.width
                holdall(f,4) = 0;
            elseif holdall(f,1) - cut_size < 0
                holdall(f,4) = 0;
            elseif holdall(f,2) + cut_size > fileInfo.height
                holdall(f,4) = 0;
            elseif holdall(f,2) - cut_size < 0
                holdall(f,4) = 0;
            end
        end
        holdall = holdall(find(holdall(:,4) == 1),:);
        filtered = [];
        for I=1:size(holdall,1)
            % Crop out area around coordinates
            cut(:,:,1:99,I) = chunk(holdall(I,2)-cut_size:holdall(I,2)+cut_size,holdall(I,1)-cut_size:holdall(I,1)+cut_size,1:99);
            %bounding box = [upper lower left right]
            bounding_box_temp = [holdall(I,2)-cut_size holdall(I,2)+cut_size holdall(I,1)-cut_size holdall(I,1)+cut_size];
            %actual pixel and north, west, south, east pixels
            trace(:,1) = squeeze(chunk(holdall(I,2),holdall(I,1),:));
            trace(:,2) = squeeze(chunk(holdall(I,2)-1,holdall(I,1),:));
            trace(:,3) = squeeze(chunk(holdall(I,2),holdall(I,1)-1,:));
            trace(:,4) = squeeze(chunk(holdall(I,2)+1,holdall(I,1),:));
            trace(:,5) = squeeze(chunk(holdall(I,2),holdall(I,1)+1,:));
            
            for z = 1:size(trace,2)
                filtered(:,z,I) = smooth(double(trace(:,z)));
            end
            %[ filtered, bounding_box_temp, cut ] = NDR_ExtractTrace( chunk, holdall(I,:), cut_size, I, filtered )

        end
        if size(filtered,3) ~= 1
            for j = 1:size(filtered,3)
                [blink,frames_found, bounding_box] = NDR_ExtractBlink(filtered(:,:,j), cut, threshold,frames_found, blink, bounding_box, bounding_box_temp);
            end
        end
    end
end

% [ new_blink, new_box ] = NDR_Remove_blanks( blink,bounding_box );
% [ fits ] = NDR_fit_stack( new_blink );