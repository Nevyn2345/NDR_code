function [ resets, fileInfo ] = NDR_DefineResets( filename, fileInfo )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

Start_frame=1;
End_frame=1000;
index=1;

test = zeros(fileInfo.height, fileInfo.width, End_frame);
for Q=Start_frame:End_frame
    framenumber=(2*(Q-1))+1; %Why does this with the frame numbers?
    [ test(:,:,index) ] = uint16(NDR_load_frame( filename,framenumber,fileInfo.width,fileInfo.height));
    index=index+1;
end

[resets, fileInfo] = NDR_FindReset(test, fileInfo);

end
