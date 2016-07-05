function [ holdall ] = NDR_check_edges( holdall,cut_size,fileInfo )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
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
end

