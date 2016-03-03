function [ image ] = NDR_Build_fittedG( fit,size )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
image=zeros(size,size);
c=fit;
for I=1:size
    for J=1:size
        image(I,J)=(c(1)*exp(-1*((((J-c(2))/c(3)).^2)+(((I-c(4)))/c(5)).^2)))+c(6);
    end
end

end

