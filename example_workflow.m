%example of work flow
%%%LOAD DATA - can take a long time so blocked off
clear
level=40;

[chunks, stout] = NDR_LoadData(); % load the data set, returns data in chunks based on resets, also returns stdev of each chunk

cut_size = 5;

[ cleaned_image ] = NDR_Select_points( stout, 1, 4 );
%%
holdall = [];
for i = 1:size(cleaned_image,3)-1
    [ holdall ] = cat(1, NDR_select_possible_events( cleaned_image(:,:,i), level, i), holdall );
end

for I=1:size(holdall,1)
    % Crop out area around coordinates
    cut(:,:,1:99,I) = chunks(holdall(I,2)-cut_size:holdall(I,2)+cut_size,holdall(I,1)-cut_size:holdall(I,1)+cut_size,1:99,holdall(I,3));
    %actual pixel and north, west, south, east pixels
    trace(:,1) = squeeze(chunks(holdall(I,2),holdall(I,1),:,holdall(I,3)));
    trace(:,2) = squeeze(chunks(holdall(I,2)-1,holdall(I,1),:,holdall(I,3)));
    trace(:,3) = squeeze(chunks(holdall(I,2),holdall(I,1)-1,:,holdall(I,3)));
    trace(:,4) = squeeze(chunks(holdall(I,2)+1,holdall(I,1),:,holdall(I,3)));
    trace(:,5) = squeeze(chunks(holdall(I,2),holdall(I,1)+1,:,holdall(I,3)));
    
    %Apply moving average filter to the data to smooth it out
    filtered(:,:,I) = MovingAvg(double(trace), 10);
    
    plot(reshape(chunks(holdall(I,2),holdall(I,1),:),1,[]));
    hold on
end
%Take the differences of the moving average

noise_trace = chunks(72,1021,:,1); %Chosen noise pixel
filterednoise = MovingAvg(double(noise_trace), 10);
figure
plot(diff(filtered(:,:,1)))
hold on
plot(diff(squeeze(filterednoise)))
plot(sum(diff(filtered(:,:,1)),2))
figure
imagesc(cut(:,:,99,1) - cut(:,:,55,1))
%% Goes through and finds blinks via a simple thresholding method
threshold = 35;

filtered2 = [];
blink_store = [];
onoff = [];
for i = 1:size(filtered,3)
    filtered2(:,i) = sum(diff(filtered(:,:,i)),2) > threshold;
    temp = diff(filtered2(:,i)); %+1 = 'turn on', -1 = 'turn off'
    indexon = find(temp == 1);
    indexoff = find(temp == -1);
    indexoff = indexoff(2:end);
    if size(indexon,1) > size(indexoff,1)
        indexoff(end+1) = size(cut,3);
    end
    if length(indexon) > length(indexoff)
        indexoff(end+1) = size(cut,3);
    end    
    for j = 1:size(indexon,1)
        if indexoff(j) - indexon(j) > 5
            disp(indexon(j))
            disp(indexoff(j))
            blink_store(:,:,end+1) = cut(:,:,indexoff(j),i) - cut(:,:,indexon(j), i);
        end
    end
    blink_store = blink_store(:,:,2:end);
end
   
