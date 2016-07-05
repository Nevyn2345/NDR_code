function [ im ] = NDR_Render2( fits )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pixelsize = 130;
rendersize = 25;

scale = pixelsize/rendersize;
maxx = max(fits(:,2));
maxy = max(fits(:,4));
im = zeros(round(maxx*scale+50),round(maxy*scale+50));
A = 1;
[R,C] = ndgrid(1:10, 1:10);

for i = 1:size(fits,1)
    left = round(fits(i,2)*scale)-size(R,1)/2; %blink position on surface
    right = round(fits(i,2)*scale)+size(R,1)/2-1;
    top = round(fits(i,4)*scale)-size(C,1)/2;
    bottom = round(fits(i,4)*scale)+size(R,1)/2-1;
    valmat = GaussC(R,C,1.5, [fits(i,2), fits(i,4)], A);
    im(left:right, top:bottom) = im(left:right, top:bottom) + valmat; %update sensor
end
figure
imagesc(im)

end

