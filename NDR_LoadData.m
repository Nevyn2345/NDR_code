function [ chunk ] = NDR_LoadData( filename, Start_frame, End_frame )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


height=180;
width=2048;

index=1;

chunk = zeros(height, width, End_frame-Start_frame);
for Q=Start_frame:End_frame-1
    framenumber=(2*(Q-1))+1; %Why does this with the frame numbers?
    [ chunk(:,:,index) ] = uint16(NDR_load_frame( filename,framenumber,width,height));
    index=index+1;
end

end

