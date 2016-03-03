function [ points ] = NDR_Findchange( Noisedata, Linedata, scale )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
lenn=length(Noisedata);
lenl=length(Linedata);

if lenn~=lenl %Need to provide data
    disp('Fail');
    points=[];
end
loop_pos=1
current_pos=1;
trigger =0;

while current_pos < lenn && trigger == 0;
    if Linedata(current_pos) > Noisedata(current_pos)*scale && Linedata(current_pos+1) > Noisedata(current_pos+1)
        trigger =1;
        points(loop_pos)=current_pos;
        loop_pos=loop_pos+1;
    end
current_pos=current_pos+1;
end


while current_pos < lenn && trigger == 1;
 if Linedata(current_pos) > Noisedata(current_pos)*scale && Linedata(current_pos+1) < Noisedata(current_pos+1)
    trigger =0;
    points(loop_pos)=current_pos;
    loop_pos=loop_pos+1;
 end
current_pos=current_pos+1;
end

    
end

