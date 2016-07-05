function [ frame_data ] = NDR_load_frame( filename,framenumber,width,height)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
offset =2880;

startposition=offset+(height*width*(framenumber-1));
frame_size=height*width;

fileID = fopen(filename,'r');
%fseek(fileID,0,'bof');
fseek(fileID,startposition,'bof');

A = fread(fileID, frame_size, 'ubit16',0, 'ieee-le');
fclose(fileID);
if length(A) / height == width
    frame_data=reshape(A,width,height)';
else
    frame_data = zeros(height, width);
end

end

