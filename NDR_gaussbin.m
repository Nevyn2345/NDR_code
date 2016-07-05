function [ blink,frames_found, bounding_box ] = NDR_gaussbin( chunk, fileInfo, level, cut_size, threshold,frames_found,blink,bounding_box,i )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% for i = 0:size(chunk,3)/2-1
%     chunk2(:,:,i+1) = chunk(:,:,i*2+1) +chunk(:,:,i*2+2);
% end
% chunk = chunk2;
%Correct for reset noise
for i = 1:size(chunk, 3)
    chunk2(:,:,i) = chunk(:,:,i) - chunk(:,:,1);
end
chunk = chunk2;

im = zeros(size(chunk));
for x = 1:size(chunk,1)
    for y = 1:size(chunk,2)
        check = 1;
        trace = [];
        if x == 1
            check = 0;
        elseif x == size(chunk,1)
            check = 0;
        elseif y == 1
            check = 0;
        elseif y == size(chunk,2)
            check = 0;
        end
        if check == 1
            trace(:,1) = squeeze(chunk(x,y,:));
            trace(:,2) = squeeze(chunk(x+1,y,:));
            trace(:,3) = squeeze(chunk(x-1,y,:));
            trace(:,4) = squeeze(chunk(x,y+1,:));
            trace(:,5) = squeeze(chunk(x,y-1,:));
            
            im(x,y,:) = squeeze(sum(trace,2));
        end
    end
end
holdall = [];

for i = 1:size(chunk,3)/10-1
    stout(:,:,i) = NDR_STDDEV(im(:,:,i*10:(i+1)*10), fileInfo);
    %cleaned_image = stout(:,:,i);
    %[ cleaned_image ] = NDR_Select_points( stout, 1, 4 )
    a(:,:,i) = imtophat(stout(:,:,i),strel('ball', 15, 5));
    b(:,:,i) = imtophat(stout(:,:,i),strel('square',5));
    cleaned_image = b(:,:,i);
    [ holdalltemp ] = NDR_select_possible_events( cleaned_image, level, i);
    holdall = [holdall; holdalltemp];
end

if size(holdall,1) > 0
    holdall(:,4) = 1;
    for f = 1:size(holdall,1)
        if holdall(f,1) + cut_size > fileInfo.cwidth
            holdall(f,4) = 0;
        elseif holdall(f,1) - cut_size < 1
            holdall(f,4) = 0;
        elseif holdall(f,2) + cut_size > fileInfo.cheight
            holdall(f,4) = 0;
        elseif holdall(f,2) - cut_size < 1
            holdall(f,4) = 0;
        end
    end
    holdall = holdall(find(holdall(:,4) == 1),:);
    filtered = [];
    for I=1:size(holdall,1)
        % Crop out area around coordinates
        cut(:,:,1:fileInfo.frequency) = chunk(holdall(I,2)-cut_size:holdall(I,2)+cut_size,holdall(I,1)-cut_size:holdall(I,1)+cut_size,1:fileInfo.frequency);
        %bounding box = [upper lower left right]
        bounding_box_temp = [holdall(I,2)-cut_size holdall(I,2)+cut_size holdall(I,1)-cut_size holdall(I,1)+cut_size];
        %actual pixel and north, west, south, east pixels
        trace(:,1) = squeeze(chunk(holdall(I,2),holdall(I,1),:));
        trace(:,2) = squeeze(chunk(holdall(I,2)-1,holdall(I,1),:));
        trace(:,3) = squeeze(chunk(holdall(I,2),holdall(I,1)-1,:));
        trace(:,4) = squeeze(chunk(holdall(I,2)+1,holdall(I,1),:));
        trace(:,5) = squeeze(chunk(holdall(I,2),holdall(I,1)+1,:));

        for z = 1:size(trace,2)
            filtered(:,z) = smooth(double(trace(:,z)));
            %[filtered(:,z), BK, FK] = CKfilteredit( double(trace(:,z)), 3, 1 );
        end
        
        [blink,frames_found, bounding_box] = NDR_ExtractBlink(filtered, cut, threshold,frames_found, blink, bounding_box, bounding_box_temp);
        
    end
end

end