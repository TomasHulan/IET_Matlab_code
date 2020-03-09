function [f fftR fr afr ld] = recalculateFFT(y,Fs,min,max)
    L=size(y,1);
    n = 2^nextpow2(L);
    Y = fft(y,n);
    f = Fs*(0:(n/2))/n;
    P = abs(Y/n); 
    P = real(P);
    fftR = P(1:n/2+1);
    l1=size(find(f<min),2);
    l2=find(f>max);
    l2=l2(1);
    fftRp=fftR;
    fftRp([1:l1 l2:end]) = 0;
    [pks,locs,widths,proms] = findpeaks(fftRp,f,'SortStr','descend','NPeaks',1);
    afr = pks;
    fr=locs;
    ld=pi*widths/(sqrt(3)*fr);
end

