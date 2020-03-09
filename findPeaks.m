% function findPeaks(Data,PeakD,AmpT,SlopeT,SmoothW,FitW,xcenter,xrange,MaxError,positions,names)
function findPeaks
D=load('test.mat');
x=1:size(D.spektrum,1);
x=x';
Data=[x D.spektrum];
ActualPeaks=0;
iPeakResults=ipeak(Data,0,0,0,80,10,round(size(x,1)/2),size(x,1),0);
SizeResults=size(iPeakResults);
error=zeros(SizeResults(1),6);
