function [ blink,frames_found, boundingbox ] = NDR_ExtractBlink2( filtered, cut, threshold,frames_found, blink, boundingbox, boundingboxtemp )


holding = [];
filtered2 = smooth(diff(sum(filtered,2)));
filtered2 = diff(filtered2);

for i = 4:size(filtered2)-4
    level(i) = sum(filtered2(i-3:i+3))/7;
    if level(i) > 1
        holding(i) = 1;
    elseif level(i) < -1
        holding(i) = -1;
    else
        holding(i) = 0;
    end
end

indexon = find(holding == 1);
indexoff = find(holding == -1);
if length(indexon) > 0
    for k = 1:size(indexon,1)
        test = indexoff(indexoff > indexon(k));
        if length(test) == 0
            test = size(cut,3);
        end
        if test(1) - indexon(k) > 5
            blink(:,:,end+1) = cut(:,:,test(1)) - cut(:,:,indexon(k));
            frames_found=[frames_found;indexon(k),test(1)];
            boundingbox = [boundingbox; boundingboxtemp];
        end
    end
end