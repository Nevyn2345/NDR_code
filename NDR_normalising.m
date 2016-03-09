function [ newchunk ] = NDR_normalising( chunk )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

for I=1:size(chunk,1)
    for J=1:size(chunk,2)
        
        mini=min(chunk(I,J,:));
        
        temp=chunk(I,J,:)-mini;
        
        maxi=max(temp);
        
        final=temp./maxi;
        
        newchunk(I,J,:)=final;
    end
end




end

