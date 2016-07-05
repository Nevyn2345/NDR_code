function [ blink,frames_found, bounding_box,cleaned_image ] = NDR_main_loop( chunk,fileInfo,level,cut_size,threshold,frames_found,blink,bounding_box,i )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    stout = NDR_STDDEV( chunk, fileInfo );
    [ cleaned_image ] = NDR_Select_points( stout, 1, 4 );
    [ holdall ] = NDR_select_possible_events( cleaned_image, level, i);
    
    if size(holdall,1) > 0
        holdall(:,4) = 1;
        for f = 1:size(holdall,1)
            if holdall(f,1) + cut_size > fileInfo.width
                holdall(f,4) = 0;
            elseif holdall(f,1) - cut_size < 1
                holdall(f,4) = 0;
            elseif holdall(f,2) + cut_size > fileInfo.height
                holdall(f,4) = 0;
            elseif holdall(f,2) - cut_size < 1
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

