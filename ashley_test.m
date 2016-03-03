% ash test

file = '/Users/Ashley/Desktop/Staph3.tsm';
load('chunk_pos.mat');

level=40;
height=180;
width=2048;
cut_size = 5;
threshold = 35;
i=32;

chunk = NDR_LoadData( file, chunk_pos(i,2), chunk_pos(i+1,2));
stout = NDR_STDDEV( chunk, height, width );
[ cleaned_image ] = NDR_Select_points( stout, 1, 4 );
[ holdall ] = NDR_select_possible_events( cleaned_image, level, i);
imagesc(cleaned_image);
hold on;
plot(holdall(:,1),holdall(:,2),'*r');

bounding_box = [];
for I=1:size(holdall,1)
            % Crop out area around coordinates
            cut(:,:,1:99,I) = chunk(holdall(I,2)-cut_size:holdall(I,2)+cut_size,holdall(I,1)-cut_size:holdall(I,1)+cut_size,1:99);
            %bounding box = [upper lower left right]
            bounding_box = [bounding_box; [holdall(I,2)-cut_size holdall(I,2)+cut_size holdall(I,1)-cut_size holdall(I,1)+cut_size]];
            %actual pixel and north, west, south, east pixels
            trace(:,1) = squeeze(chunk(holdall(I,2),holdall(I,1),:));
            trace(:,2) = squeeze(chunk(holdall(I,2)-1,holdall(I,1),:));
            trace(:,3) = squeeze(chunk(holdall(I,2),holdall(I,1)-1,:));
            trace(:,4) = squeeze(chunk(holdall(I,2)+1,holdall(I,1),:));
            trace(:,5) = squeeze(chunk(holdall(I,2),holdall(I,1)+1,:));

            %Apply moving average filter to the data to smooth it out, can
            %probably just use the smooth() function, need to look into
            filtered(:,:,I) = MovingAvg(double(trace), 10);
end

blink_store = [];
 
        threshold = 35;

        for j = 1:size(filtered,3)
            blink_store(:,:,end+1) = NDR_ExtractBlink(filtered(:,:,j), cut, threshold);
        end
       [ new_blink, new_box ] = NDR_Remove_blanks( blink_store,bounding_box );
       [ fits ] = NDR_fit_stack( new_blink );
       
       
           subplot(2,3,1);
           imagesc(new_blink(:,:,1));
           subplot(2,3,2);
           imagesc(NDR_Build_fittedG( fits(1,:),11 ));
           subplot(2,3,3);
           imagesc(NDR_Build_fittedG( fits(1,:),11 )-new_blink(:,:,1));
           
           
           subplot(2,3,4);
           imagesc(new_blink(:,:,2));
           subplot(2,3,5);
           imagesc(NDR_Build_fittedG( fits(2,:),11 ));
           subplot(2,3,6);
           imagesc(NDR_Build_fittedG( fits(2,:),11 )-new_blink(:,:,2));
     
    
        
       
       
        
        
        
        
        