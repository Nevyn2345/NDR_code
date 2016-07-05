 load('blinks.mat');
mask=zeros(11,11);
mask(1,:)=1;
mask(:,1)=1;
mask(:,11)=1;
mask(11,:)=1;


for I=1:size(blink,3)
    
noise_mat=mask.*blink(:,:,I);
noise=sum(sum(noise_mat))./(11+9+11+9);
sig=max(max(blink(:,:,I)));
SNR(I)=sig./noise;

    
end

hist(SNR,2000);
axis([0 15 0 200]);