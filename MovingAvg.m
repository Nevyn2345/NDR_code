function [ avgA ] = MovingAvg( data, average )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

coeff = ones(1, average)/average;
avgA = filter(coeff, 1, double(data));
%plot(1:size(data,1), [data, avgA])



end