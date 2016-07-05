function [ blink,frames_found, bounding_box ] = NDR_return_blinks( holdall,file,cut_size,chunk_pos,i,fileInfo, blink, frames_found, bounding_box,threshold )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[ holdall ] = NDR_check_edges( holdall,cut_size,fileInfo );
        
chunk=NDR_LoadData( file, chunk_pos(i,2), chunk_pos(i+1,2));
[ filtered,bounding_box_temp, cut ] = NDR_cut_sections( holdall,cut_size, chunk );

if size(filtered,3) ~= 1
    for j = 1:size(filtered,3)
       [blink,frames_found, bounding_box] = NDR_ExtractBlink(filtered(:,:,j), cut, threshold,frames_found, blink, bounding_box, bounding_box_temp);
    end
end

end

