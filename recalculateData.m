function [ SData ] = recalculateData( SData );

SData.l=nanmean(SData.SampleDim.l);
SData.lu=sqrt((std(SData.SampleDim.l,'omitnan')/sqrt(size(SData.SampleDim.l,2)-sum(isnan(SData.SampleDim.l))))^2+0.02^2);

if(isequal(SData.shape,'r'))
    SData.a=nanmean(SData.SampleDim.a);
    SData.au=sqrt((std(SData.SampleDim.a,'omitnan')/sqrt(size(SData.SampleDim.a,2)-sum(isnan(SData.SampleDim.a))))^2+0.02^2);
    SData.b=nanmean(SData.SampleDim.b);
    SData.bu=sqrt((std(SData.SampleDim.b,'omitnan')/sqrt(size(SData.SampleDim.b,2)-sum(isnan(SData.SampleDim.b))))^2+0.02^2);
    %SData.fa=nanmean(SData.SampleDim.fa);
    %SData.fau=sqrt((std(SData.SampleDim.fa,'omitnan')/sqrt(size(SData.SampleDim.fa,2)-sum(isnan(SData.SampleDim.fa))))^2+1^2);
    %SData.fb=nanmean(SData.SampleDim.fb);
    %SData.fbu=sqrt((std(SData.SampleDim.fb,'omitnan')/sqrt(size(SData.SampleDim.fb,2)-sum(isnan(SData.SampleDim.fb))))^2+1^2);

    %Ta = 1 + 6.585 * (1 + 0.0752 * SData.u + 0.8109 * SData.u^2) * (SData.b/SData.l)^2 - 0.868*(SData.b/SData.l)^4 -...
    ((8.340*(1+0.2023*SData.u + 2.173 * SData.u^2)*(SData.b/SData.l)^4) / ...
    (1 + 6.338 *(1+0.1408 * SData.u + 1.536 *SData.u^2)*(SData.b/SData.l)^2));
    
    %SData.Ea=0.9465*(SData.m*SData.fa^2/SData.a)*(SData.l^3/SData.b^3)*Ta*0.000000001;
    
    %dma=0.9465*(SData.fa^2/SData.a)*(SData.l^3/SData.b^3)*Ta;
    %dfa=1.893*(SData.m*SData.fa/SData.a)*(SData.l^3/SData.b^3)*Ta;
    %dla=2.8395*(SData.m*SData.fa^2/SData.a)*(SData.l^2/SData.b^3)*Ta;
    %daa=-0.9465*(SData.m*SData.fa^2/SData.a^2)*(SData.l^3/SData.b^3)*Ta;
    %dba=-2.8395*(SData.m*SData.fa^2/SData.a)*(SData.l^3/SData.b^4)*Ta;
    
    %SData.Eau=sqrt((dma*SData.mu)^2+(dfa*SData.fau)^2+(dla*SData.lu)^2+(daa*SData.au)^2+(dba*SData.bu)^2)*0.000000001;

    Tb = 1 + 6.585 * (1 + 0.0752 * SData.u + 0.8109 * SData.u^2) * (SData.a/SData.l)^2 - 0.868*(SData.a/SData.l)^4 -...
    ((8.340*(1+0.2023*SData.u + 2.173 * SData.u^2)*(SData.a/SData.l)^4) / ...
    (1 + 6.338 *(1+0.1408 * SData.u + 1.536 *SData.u^2)*(SData.a/SData.l)^2));
    
    %SData.Eb=0.9465*(SData.m*SData.fb^2/SData.a)*(SData.l^3/SData.a^3)*Tb*0.000000001;

    %dmb=0.9465*(SData.fb^2/SData.b)*(SData.l^3/SData.a^3)*Tb;
    %dfb=1.893*(SData.m*SData.fb/SData.b)*(SData.l^3/SData.a^3)*Tb;
    %dlb=2.8395*(SData.m*SData.fb^2/SData.b)*(SData.l^2/SData.a^3)*Tb;
    %dab=-0.9465*(SData.m*SData.fb^2/SData.b^2)*(SData.l^3/SData.a^3)*Tb;
    %dbb=-2.8395*(SData.m*SData.fb^2/SData.b)*(SData.l^3/SData.a^4)*Tb;
    
    %SData.Ebu=sqrt((dmb*SData.mu)^2+(dfb*SData.fbu)^2+(dlb*SData.lu)^2+(dab*SData.au)^2+(dbb*SData.bu)^2)*0.000000001;
    
    %SData.deka=nanmean(SData.SampleDim.deka);
    %SData.dekau=sqrt((std(SData.SampleDim.deka,'omitnan')/sqrt(size(SData.SampleDim.deka,2)-sum(isnan(SData.SampleDim.deka))))^2);
    
    %SData.dekb=nanmean(SData.SampleDim.dekb);
    %SData.dekbu=sqrt((std(SData.SampleDim.dekb,'omitnan')/sqrt(size(SData.SampleDim.dekb,2)-sum(isnan(SData.SampleDim.dekb))))^2);
    
    rdm=1/(SData.a*SData.b*SData.l);
    rdl=-SData.m/(SData.a*SData.b*SData.l^2);
    rda=-SData.m/(SData.a^2*SData.b*SData.l);
    rdb=-SData.m/(SData.a*SData.b^2*SData.l);
    
    SData.density=SData.m/(SData.a*SData.b*SData.l)*1000;
    SData.uDensity=sqrt((rdm*SData.mu)^2+(rdl*SData.lu)^2+(rda*SData.au)^2+(rdb*SData.bu)^2)*1000;
end

if(isequal(SData.shape,'c'))
    SData.d=nanmean(SData.SampleDim.d);
    SData.du=sqrt((std(SData.SampleDim.d,'omitnan')/sqrt(size(SData.SampleDim.d,2)-sum(isnan(SData.SampleDim.d))))^2+0.02^2);
    %SData.fd=nanmean(SData.SampleDim.fd);
    %SData.fdu=sqrt((std(SData.SampleDim.fd,'omitnan')/sqrt(size(SData.SampleDim.fd,2)-sum(isnan(SData.SampleDim.fd))))^2+1^2);
    
    %Td = 1 + 4.939 * (1 + 0.0752 * SData.u + 0.8109 * SData.u^2) * (SData.d/SData.l)^2 - 0.4883*(SData.d/SData.l)^4 -...
    ((4.691*(1+0.2023 * SData.u + 2.173 * SData.u^2)>(SData.d/SData.l)^4) / ...
    (1 + 4.754 *(1+0.1408 * SData.u + 1.536 *SData.u^2)*(SData.d/SData.l)^2));
    %SData.Ed=1.6067*(SData.l^3/SData.d^4)*(SData.m*SData.fd^2)*Td*0.000000001;
    
    %dmd=1.6067*(SData.l^3/SData.d^4)*(SData.fd^2)*Td;
    %dfd=3.2134*(SData.l^3/SData.d^4)*(SData.m*SData.fd)*Td;
    %dld=4.8201*(SData.l^2/SData.d^4)*(SData.m*SData.fd^2)*Td;
    %dd=-6.4268*(SData.l^3/SData.d^5)*(SData.m*SData.fd^2)*Td;
    
    %SData.Edu=sqrt((dmd*SData.mu)^2+(dfd*SData.fdu)^2+(dld*SData.lu)^2+(dd*SData.bu)^2)*0.000000001;
    
    %SData.dekd=nanmean(SData.SampleDim.dekd);
    %SData.dekdu=sqrt((std(SData.SampleDim.dekd,'omitnan')/sqrt(size(SData.SampleDim.dekd,2)-sum(isnan(SData.SampleDim.dekd))))^2);
    
    rdm=4/(pi*SData.d^2*SData.l);
    rdl=-8*SData.m/(pi*SData.d^3*SData.l);
    rdd=-4*SData.m/(pi*SData.d^2*SData.l^2);
    
    SData.density=SData.m/(pi*(SData.d/2)^2*SData.l)*1000;
    SData.uDensity=sqrt((rdm*SData.mu)^2+(rdl*SData.lu)^2+(rdd*SData.du)^2)*1000;
end
end

