% load('cut2.mat')
start =3;
length=50;
new_cut=cut(:,:,start:start+length);
for I=1:size(new_cut,3)
    new_new_cut(:,:,I)=new_cut(:,:,I)-new_cut(:,:,start-1);
end
temp_sign=(new_new_cut(6:8,6:8,:));
sign=sum(sum(temp_sign,1),2);
sign=reshape(sign,1,[]);

sign=sign./(((8-6)+1).*((7-6))+1);

mask=zeros(11,11);
mask(11,:)=1;
mask(1,:)=1;
mask(:,11)=1;
mask(:,1)=1;
for I=1:size(new_cut,3)
noise_cut(:,:,I)=mask.*cut(:,:,I);
end

noise=reshape(sum(sum(noise_cut,1),2),1,[]);
noise=noise./20;

plot(smooth(sign./noise),'*-');
axis([2 50 1 2.5]);
