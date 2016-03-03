function [ filtered, bounding_box_temp, cut ] = NDR_ExtractTrace( chunk, holdall, cut_size, I, filtered )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


% Crop out area around coordinates
cut(:,:,1:99,I) = chunk(holdall(2)-cut_size:holdall(2)+cut_size,holdall(1)-cut_size:holdall(1)+cut_size,1:99);
%bounding box = [upper lower left right]
bounding_box_temp = [holdall(2)-cut_size holdall(2)+cut_size holdall(1)-cut_size holdall(1)+cut_size];
%actual pixel and north, west, south, east pixels
trace(:,1) = squeeze(chunk(holdall(2),holdall(1),:));
trace(:,2) = squeeze(chunk(holdall(2)-1,holdall(1),:));
trace(:,3) = squeeze(chunk(holdall(2),holdall(1)-1,:));
trace(:,4) = squeeze(chunk(holdall(2)+1,holdall(1),:));
trace(:,5) = squeeze(chunk(holdall(2),holdall(1)+1,:));

for z = 1:size(trace,2)
    filtered(:,z,end+1) = smooth(double(trace(:,z)));
end

end

