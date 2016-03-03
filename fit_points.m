XY=(cut_size*2)+1;
[X,Y]=meshgrid(1:XY,1:XY); %your x-y coordinates
x(:,1)=X(:); % x= first column
x(:,2)=Y(:); % y= second column 

point_to_use=16;

Z=reshape(blink_store(:,:,point_to_use),(cut_size*2)+1,(cut_size*2)+1);
options=optimset('Display','off','TolFun',1e-8,'TolX',1e-8,'MaxFunEvals',500);
lower=[0,0,0,0,0,0];
upper=[1000,1000,1000,1000,1000,1000];
guesses=[100,3,3,3,3,10];
[bestfit,~,~,~]=lsqcurvefit(@Gaussian2D,guesses,x,Z(:),lower,upper,options);

c=bestfit;
subplot(1,2,1);
imagesc(blink_store(:,:,point_to_use));
compare=zeros((cut_size*2)+1,(cut_size*2)+1);
for I=1:(cut_size*2)+1
    for J=1:(cut_size*2)+1
      compare(I,J)  = (c(1)*exp(-1*((((I-c(2))/c(3)).^2)+(((J-c(4)))/c(5)).^2)))+c(6);
    end
end
subplot(1,2,2);
imagesc(compare);