function [ stout ] = NDR_STDDEV( chunk, height, width )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



%Standard Deviation of each chunk
stout = zeros(height, width);
for x=1:size(chunk,1)
    for y=1:size(chunk,2)
        stout(x,y)=std(double(squeeze(chunk(x,y,:))));
    end
end



end

