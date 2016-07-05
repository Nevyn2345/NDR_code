function [ fileInfo ] = NDR_FileInfo( file )
%NDR_FileInfo, loads relevant information from file
%   reads in the file as little-endian uint8, stores the data as a
%   structure

fileID = fopen(file);
fseek(fileID, 266, 'bof'); %bof = beginning of file
width = char(fread(fileID,4, 'uint8',0,'ieee-le'));
width = str2num(strcat(width'));
fseek(fileID, 347, 'bof');
height = char(fread(fileID,4, 'uint8',0,'ieee-le'));
height = str2num(strcat(height'));
fseek(fileID, 425, 'bof');
nframes = char(fread(fileID,6, 'uint8',0,'ieee-le'));
nframes = str2num(strcat(nframes'));
fclose(fileID);
fileInfo = struct('width', width, 'height', height, 'nframes', nframes);

end

