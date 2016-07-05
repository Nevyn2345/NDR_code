function [ stout,cleaned_image ] = NDR_return_images( file,chunk_pos,fileInfo,i )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

chunk = NDR_LoadData( file, chunk_pos(i,2), chunk_pos(i+1,2));
%[chunk ] = NDR_normalising( chunk )
stout = NDR_STDDEV( chunk, fileInfo );
[ cleaned_image ] = NDR_Select_points( stout, 1, 4 );

end

