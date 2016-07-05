function [ resets_out, fileInfo ] = NDR_FindReset( frames, fileInfo )
%Find the frame resets
%   Detailed explanation goes here

m = [];
resets = [1];

for i = 1:size(frames, 3)
    m(i) = mean2(frames(:,:,i)); %mean of the frames
    if i > 1
        if m(i) - m(i-1) < -50 %amount reset decreases by
            resets(end + 1) = i;
        end
    end
end

manager = 0;
tempresets = resets;
for i = 1:size(tempresets,2)-1
    if tempresets(i+1) - tempresets(i) == 1
        resets(i-manager) = [];
        manager = manager+1;
    end
end

plot(m)
hold on
plot(resets, m(resets), 'ro')

frames = frames(:,:,resets(2):end); %Lose the beginning chunk otherwise they won't be the same size
if size(resets,2) > 2
    disp([int2str(resets(2)), ' frames dropped to first reset']);
    reset_freq = resets(3) - resets(2);
    fileInfo.frequency = reset_freq;
    disp(['Reset frequency is: ', int2str(reset_freq)])
    resets = resets';
    for i = 1:fileInfo.nframes/reset_freq
        resets_out(i,1) = i;
        resets_out(i,2) = (i-1)*reset_freq+resets(2);
    end
else
    disp(['ERROR: Not enough resets found!'])
    error('ERROR: Not enough resets found!')
    return
end

end

