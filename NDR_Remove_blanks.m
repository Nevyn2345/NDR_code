function [ new_blink, new_box ] = NDR_Remove_blanks( blink_store,bounding_box )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

blink_store=blink_store(:,:,2:end);
new_blink=[];
count =1;
for I=1:size(blink_store,3)
    if sum(sum(blink_store(:,:,I))) > 0
        new_blink(:,:,count)=blink_store(:,:,I);
        new_box(count,:)=bounding_box(I,:);
        count=count+1;
    end
    
    
end

end

