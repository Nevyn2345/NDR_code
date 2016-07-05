% Look at the mean intensity per frame
meim = reshape(mean(mean(chunk,1),2),1,100);
%hist(meim,'Normalization','probability')

% Look at the mean frame
avim = mean(chunk,3);
imagesc(avim)

% Have a quick look at the traces
suse = chunk(70:80,975:1000,:);
kk = reshape(suse,11*26,[]);
plot(1:100,kk)

% IDEA: look at the overall relative change.  Given that each frame is the previous plus 'something', 
% those with no change are noise and those with larger changes may have an event.
x0 = reshape(chunk(:,:,1),[],1);
xn = reshape(chunk(:,:,end),[],1);
mech = (xn-x0)./x0;

kk = histogram(mech,'Normalization','probability');
mv = find(kk.Values==max(kk.Values));
mova = mean(kk.BinEdges([mv,mv+1]))
line([mova, mova],[0,max(kk.Values)],'Color',[1,0,0])

% There seems to be two 'clear' populations.  Given that noise should be relatively
% Gaussian, we can identify it by +- k standard deviations

% IDEA: the lower limit is about 3 std deviations from the mean noise, then I used k=2.5 to 
% separate noise from possible signals
stde = (mova - min(mech))/3;
lim= 2.5;
noi = mech(mech<= mova+lim*stde);
sig = mech(mech> mova+lim*stde);

subplot(1,2,1)
histogram(noi,'Normalization','probability')
subplot(1,2,2)
histogram(sig,'Normalization','probability')

% some numerical summaries
a = quantile(noi,[0.01,0.025,1/2,0.975,0.99])
b = quantile(sig,[0.01,0.025,1/2,0.975,0.99])

% You could then feed 'sig' to Sam's code.