function [ filtered,bounding_box_temp, cut ] = NDR_cut_sections( holdall,cut_size,chunk )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

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


end

