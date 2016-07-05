

[filename, Path] = uigetfile('*.tsm');

file = strcat(Path,filename);
fileInfo = NDR_FileInfo(file);
outpath = 'C:\Users\Sam\Documents\ndr_data\test\';
num = '000000';
%%
length = 2880 + ((2*(300-1))+1)*fileInfo.height*fileInfo.width
fileID = fopen(file,'r');
data = fread(fileID,length, 'uint8',0,'ieee-le');
fclose(fileID)
fileID = fopen('test.tsm', 'w')
fwrite(fileID, data)

%%
for i = 1:fileInfo.nframes
    framenumber=(2*(i-1))+1;
    a = NDR_load_frame( file,framenumber,fileInfo.width,fileInfo.height);
    %a = a(65:180, 110:320);
    num = length(num2str(i));
    mismatch = repmat('0', 1, 6-num);
    imwrite(uint16(a), strcat(outpath, 'out', mismatch, num2str(i), '.tif'));
end