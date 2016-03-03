function [ fits ] = NDR_fit_stack( Image_stack )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[Xs,Ys,Zs]=size(Image_stack);

XY = Xs;
[X,Y]=meshgrid(1:XY,1:XY); %your x-y coordinates
x(:,1)=X(:); % x= first column
x(:,2)=Y(:); % y= second column 
fits  = [];
for point_to_use=1:Zs

    Z=reshape(Image_stack(:,:,point_to_use),Xs,Xs);
    options=optimset('Display','off','TolFun',1e-8,'TolX',1e-8,'MaxFunEvals',500);
    %
    %First is scalling
    %Second is X pso
    %Third is X width
    %Fourth is Y pos
    %Fith os Y wdth
    %6 is off set
    %
    lower=[1,1,1,1,1,0];
    %The widths need to be better done

    upper=[1000,Xs,1000,Xs,1000,1000];
    guesses=[max(max(Image_stack(:,:,point_to_use))),Xs/2,3,Xs/2,3,min(min(Image_stack(:,:,point_to_use)))];


    [bestfit,~,~,~]=lsqcurvefit(@Gaussian2D,guesses,x,Z(:),lower,upper,options);
    
    fits = [fits; bestfit];

end

%fits=[];

end

