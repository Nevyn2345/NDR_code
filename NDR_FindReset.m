function [ resets_out ] = NDR_FindReset( frames, height, width, numframes )
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

% plot(m)
% hold on
% plot(resets, m(resets), 'ro')

frames = frames(:,:,resets(2):end); %Lose the beginning chunk otherwise they won't be the same size
disp([int2str(resets(2)), ' frames dropped to first reset']);
reset_freq = resets(3) - resets(2);

resets = resets';
for i = 1:numframes/reset_freq
    resets_out(i,1) = i;
    resets_out(i,2) = (i-1)*reset_freq+resets(2);
end

end

