function F = Gaussian2D(c,xdata)
%F = (c(1)*exp(-1*((((xdata(:,1)-c(2)).^2)/c(3))+(((xdata(:,2)-c(4)).^2))/c(5))))+c(6);
F = (c(1)*exp(-1*((((xdata(:,1)-c(2))/c(3)).^2)+(((xdata(:,2)-c(4)))/c(5)).^2)))+c(6);