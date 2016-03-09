%playing with the chunk

x=1:100;


ft=fittype({'x','1'});


for I=1:size(chunk,1)
    for J=1:size(chunk,2)
        
        [myfit, gof]=fit(x',reshape(chunk(I,J,:),[],1),ft);
        %plot(myfit,x,y);
      
        newmatrix(I,J)=myfit.a;
        gofsse(I,J) = gof.sse;
        gofrmse(I,J) = gof.rmse;
        tempfile=reshape(chunk(I,J,:),[],1)'-((x*myfit.a)+myfit.b);
        newmatrixd(I,J)=sum(tempfile);
    end
      disp(I);
end