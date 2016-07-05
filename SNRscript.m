%load('cut2.mat')
start =10;
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

b=4.75;
c=79.36;
x=1:20;
comp_noise=(x*b)+((c*sqrt(12*2.8.^2))./((x.^3)-x));
a=9.3;
comp_sig=a*x;


plot(x+1,comp_sig./comp_noise,'r','LineWidth',2);
hold on;
plot(smooth(sign./noise),'b*-');
axis([2 50 1 2.5]);
