function [ blink,frames_found, boundingbox ] = NDR_ExtractBlink( filtered, cut, threshold,frames_found, blink, boundingbox, boundingboxtemp )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


filtered2 = sum(diff(filtered),2) > threshold;
temp = diff(filtered2); %+1 = 'turn on', -1 = 'turn off'
indexon = find(temp == 1);
indexoff = find(temp == -1);
if length(indexon) > length(indexoff)
    indexoff(end+1) = size(cut,3);
end

for k = 1:size(indexon,1)
    if indexoff(k) - indexon(k) > 5
        blink(:,:,end+1) = cut(:,:,indexoff(k)) - cut(:,:,indexon(k));
        frames_found=[frames_found;indexon(k),indexoff(k)];
        boundingbox = [boundingbox; boundingboxtemp];
    end
end
%if isempty(blink)
%   blink=0;
%end
end

