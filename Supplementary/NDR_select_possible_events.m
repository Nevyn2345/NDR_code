function [ coordinates ] = NDR_select_possible_events( cleaned_image,level, chunk_pos)
%Long shot here, going to take the brighest pixels and look fo
%discontinuiteis (sp) in time for those pixels.
temp_matrix=zeros(size(cleaned_image));

max_positions=find(cleaned_image > level); %gets all the points above level

temp_matrix(max_positions)=1;

CC=bwconncomp(temp_matrix);

selected_areas=regionprops(CC,'Centroid','PixelList');
coordinates = [];

for I=1:size(selected_areas,1)
    temp=selected_areas(I).PixelList;
    linearpos=sub2ind(size(cleaned_image),temp(:,2),temp(:,1));
    indy=find(cleaned_image(linearpos)==max(cleaned_image(linearpos)));
    try
        [coordinates(I,2),coordinates(I,1)]=ind2sub(size(cleaned_image),linearpos(indy));
    catch
%         size(cleaned_image)
%         indy
    end
end

if size(coordinates,1) ~= 0
    coordinates(:,3) = chunk_pos;
end

end

