function [ stout ] = NDR_STDDEV( chunk, fileInfo )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Standard Deviation of each chunk, this code is 36x faster than the old
stout = std(chunk, [], 3);

%%%% DEPRECIATED %%%%

% stout = zeros(fileInfo.cheight, fileInfo.cwidth);
% for x=1:size(chunk,1)
%     for y=1:size(chunk,2)
%         stout(x,y)=std(double(squeeze(chunk(x,y,:))));
%     end
% end

end

