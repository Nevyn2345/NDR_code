function [ newdata, BK, FK] = CKfilteredit( data, width, p )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
clean=1;
[A B]=size(data);
XF=zeros(A,1);
XB=zeros(A,1);
FK=zeros(A,1);
BK=zeros(A,1);
BKraw=zeros(A,1);
FKraw=zeros(A,1);
newdata=zeros(A,1);

% form an average from the previous data points


for k=width+1:A
    XF(k)=mean(data((k-width):(k-1)));
end

% form an average from the upcoming data points

for k=1:A-width
    XB(k)=mean(data((k+1):(k+width)));
end
   


% calculate the coeff


for k=width+1:A
    total=sum((data((k-width+1):k)-XF((k-width+1):k)).^2);
    FKraw(k)=total^(-p);
end


for k=1:A-width
    total=sum((data(k:(k+width-1))-XB(k:(k+width-1))).^2);
    BKraw(k)=total^(-p);
end


BK=BKraw./(BKraw+FKraw);
FK=FKraw./(BKraw+FKraw);
newdata=(FK.*XF)+(BK.*XB);

%clf;
%plot(newdata(clean:end),'b.');
%hold on;
%plot(data(clean:end),'r');

end

