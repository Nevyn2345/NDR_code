function [ chunk2 ] = NDR_Binning( chunk, binfactor )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

j = 1;

leftover = rem(size(chunk,3), binfactor);

if leftover ~= 0
    if leftover == 1
        disp([leftover, ' frame dropped during binning']);
    else
        disp([leftover, ' frames dropped during binning']);
    end
end

for i = 1:size(chunk, 3)/binfactor
    chunk2(:,:,i) = sum(chunk(:,:,j:j+binfactor), 3);
    j = i*binfactor + 1;
end


end

