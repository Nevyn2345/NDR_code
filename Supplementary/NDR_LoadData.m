function [ chunk ] = NDR_LoadData( filename, Start_frame, End_frame, fileInfo )
%NDR_LoadData: Takes the filepath, frame start number, end frame number and
%file info to load the data into memory
%   fileInfo is a structure containing the following elements:
%         -width     || Width of frame
%         -height    || Height of frame
%         -nframes   || Number of frames in file
%         -frequency || How often reset frames occure in frames


index=1;

chunk = zeros(fileInfo.height, fileInfo.width, End_frame-Start_frame);
for Q=Start_frame:End_frame-1
    framenumber=(2*(Q-1))+1;
    [ chunk(:,:,index) ] = uint16(NDR_load_frame( filename,framenumber,fileInfo.width,fileInfo.height));
    index=index+1;
end

end

