%% NEW WORKFLOW

clear
level=40;
height=180;
width=2048;

[filename, Path] = uigetfile('*.tsm');
file = strcat(Path,filename);

[chunk_pos] = NDR_DefineResets( file ); % load beginning of file, find resets, returns list of reset locations
%%
cut_size = 5;
threshold = 35;
blink_store = [];
bounding_box = [];
for i = 1:size(chunk_pos,1)-1 %-1 because last chunk is also not a full chunk
    chunk = NDR_LoadData( file, chunk_pos(i,2), chunk_pos(i+1,2));
    stout = NDR_STDDEV( chunk, height, width );
    [ cleaned_image ] = NDR_Select_points( stout, 1, 4 );
    
    [ holdall ] = NDR_select_possible_events( cleaned_image, level, i);
    if size(holdall,1) > 0
        filtered = [];
        for I=1:2%size(holdall,1)
            % Crop out area around coordinates
            cut(:,:,1:99) = chunk(holdall(I,2)-cut_size:holdall(I,2)+cut_size,holdall(I,1)-cut_size:holdall(I,1)+cut_size,1:99);
            %bounding box = [upper lower left right]
            bounding_box = [bounding_box; [holdall(I,2)-cut_size holdall(I,2)+cut_size holdall(I,1)-cut_size holdall(I,1)+cut_size]];
            %actual pixel and north, west, south, east pixels
            trace(:,1) = squeeze(chunk(holdall(I,2),holdall(I,1),:));
            trace(:,1) = squeeze(chunk(holdall(I,2)-1,holdall(I,1),:));
            trace(:,3) = squeeze(chunk(holdall(I,2),holdall(I,1)-1,:));
            trace(:,4) = squeeze(chunk(holdall(I,2)+1,holdall(I,1),:));
            trace(:,5) = squeeze(chunk(holdall(I,2),holdall(I,1)+1,:));

            %Apply moving average filter to the data to smooth it out, can
            %probably just use the smooth() function, need to look into
            for z = 1:size(trace,2)
                filtered(:,z,I) = smooth(double(trace(:,z)));
            end
      %      subplot(5,5,I+5)
       %     plot(sum(diff(filtered),2))
        end


        filtered2 = [];
        threshold = 35;

        for j = 1:size(filtered,3)
            blink_store(:,:,end+1) = NDR_ExtractBlink(filtered{A}(:,:,j), cut(I,:,:,:), threshold);
        end
    end
end
blink_store = blink_store(:,:,2:end);

[ new_blink, new_box ] = NDR_Remove_blanks( blink_store,bounding_box );
[ fits ] = NDR_fit_stack( new_blink );


