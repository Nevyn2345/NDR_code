function [ resets ] = NDR_DefineResets( filename )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

Start_frame=1;
End_frame=1000;
height=180;
width=2048;
numframes = 40000;

index=1;

test = zeros(height, width, End_frame);
for Q=Start_frame:End_frame
    framenumber=(2*(Q-1))+1; %Why does this with the frame numbers?
    [ test(:,:,index) ] = uint16(NDR_load_frame( filename,framenumber,width,height));
    index=index+1;
end

resets = NDR_FindReset(test, height, width, numframes);

end

