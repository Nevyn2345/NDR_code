function [ outfits ] = NDR_Fits_filter( fits,Xs,Xm,Ys,Ym )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fits2=fits(fits(:,3) >Xs,:);
fits3=fits2(fits2(:,3) <Xm,:);
fits4=fits3(fits3(:,5) >Ys,:);
outfits=fits4(fits4(:,5) <Ym,:);

end

