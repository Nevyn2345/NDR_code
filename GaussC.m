function [ valmat ] = GaussC(R,C, sigma, center, A )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
xc = size(R,1)/2+mod(center(1),1);
yc = size(C,1)/2+mod(center(2),1);

%exponent(1:5,1:5) = ((R-xc).^2 + (C-yc).^2)./(2*sigma^2);
exponent = ((R-xc).^2 + (C-yc).^2)./(2*sigma^2);

valmat = A*exp(-exponent);


end

