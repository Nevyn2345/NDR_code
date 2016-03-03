function [ cleaned_image ] = NDR_Select_points( Std_matrix, sigma1, sigma2 )
%This function takes the sum of gaussian across the standard image to pick
% out regions of interest, it might be worth doing wavelent analysis on
% this, if this diff of gaussians doesnt work that well.
% try NDR_Select_points( Std_matrix, 1, 4 )

A = imgaussfilt(Std_matrix,sigma1);
B = imgaussfilt(Std_matrix,sigma2);
cleaned_image=abs(B-A);



end

