Start_frame=1;
End_frame=500;
height=180;
width=2048;

[filename, Path] = uigetfile('*.tsm');
file = strcat(Path,filename);

filename=file;
index=1;
for Q=Start_frame:End_frame
    framenumber=(2*(Q-1))+1; %Why does this with the frame numbers?
    [ test(:,:,index) ] = uint16(NDR_load_frame( filename,framenumber,width,height));
    index=index+1;
end

%%

m = [];
resets = [];

for i = 1:size(test, 3)
    m(i) = mean2(test(:,:,i));
    if i > 1
        if abs(m(i) - m(i-1)) > 50
            resets(end + 1) = i;
        end
    end
end
plot(reshape(sum(sum(test)),1,[]));
%%

for x=1:size(test,1)
    for y=1:size(test,2)
        stout(x,y)=std(double(test(x,y,:)));
    end
end



