%Load and plot LDA, CCF and LVF from Levy et al 2014

[S,A]=shaperead('LDA_vol_thick.shp');

for ii=1:length(S);
    data=A(ii);
    are_LDA(ii)=data.Area_km2;
    vol_LDA(ii)=data.Vol_km3;
    lat_LDA(ii)=data.Lat;
    lon_LDA(ii)=data.Long;
end
id0=find(are_LDA~=0 & vol_LDA~=0);
are_LDA2=are_LDA(id0);
vol_LDA2=vol_LDA(id0);

[S,A]=shaperead('CCF_vol_thick.shp');

for ii=1:length(S);
    data=A(ii);
    are_CCF(ii)=data.Shape_Area/1000^2;
    vol_CCF(ii)=data.volkm3;
    lat_CCF(ii)=data.Lat;
    lon_CCF(ii)=data.Long;
end

[S,A]=shaperead('LVF_vol_thick.shp');

for ii=1:length(S);
    data=A(ii);
    are_LVF(ii)=data.Shape_Area/1000^2;
    vol_LVF(ii)=data.Vol_km3;
    lat_LVF(ii)=data.Lat;
    lon_LVF(ii)=data.Long;
end


return

figure
plot(log(are_LDA2),log(vol_LDA2),'.')
hold on
plot(log(are_CCF),log(vol_CCF),'.r')
plot(log(are_LVF),log(vol_LVF),'g.')


figure
loglog(are_CCF,vol_CCF,'.r')
hold on
loglog(are_LDA2,vol_LDA2,'.')
loglog(are_LVF,vol_LVF,'g.')
legend('CCF','LDA','LVF')
xlabel('Area km^2')
ylabel('Vol km^3')

[p,R]=polyfit(log(are_LDA2),log(vol_LDA2),1);
logvolfit=polyval(p,log(are_LDA2));
logvolres=log(vol_LDA2)-logvolfit;
SSres=sum(logvolres.^2);
SStot=(length(log(vol_LDA2))-1)*var(log(vol_LDA2));
rsq_LDA=1-SSres/SStot;
p_LDA=p;
loglog(are_LDA2,exp(logvolfit),'b')

[p,R]=polyfit(log(are_CCF),log(vol_CCF),1);
logvolfit=polyval(p,log(are_CCF));
logvolres=log(vol_CCF)-logvolfit;
SSres=sum(logvolres.^2);
SStot=(length(log(vol_CCF))-1)*var(log(vol_CCF));
rsq_CCF=1-SSres/SStot;
p_CCF=p;
loglog(are_CCF,exp(logvolfit),'r')

[p,R]=polyfit(log(are_LVF),log(vol_LVF),1);
logvolfit=polyval(p,log(are_LVF));
logvolres=log(vol_LVF)-logvolfit;
SSres=sum(logvolres.^2);
SStot=(length(log(vol_LVF))-1)*var(log(vol_LVF));
rsq_LVF=1-SSres/SStot;
p_LVF=p;
loglog(are_LVF,exp(logvolfit),'g')

text(10^-1,10^-3,['Log(V)= ' num2str(p_LDA(1)) 'log(A) + ' num2str(p_LDA(2)) ', R^2 = ' num2str(rsq_LDA)],'Color','b')
text(10^-1,10^-4,['Log(V)= ' num2str(p_CCF(1)) 'log(A) + ' num2str(p_CCF(2)) ', R^2 = ' num2str(rsq_CCF)],'Color','r')
text(10^-1,10^-5,['Log(V)= ' num2str(p_LVF(1)) 'log(A) + ' num2str(p_LVF(2)) ', R^2 = ' num2str(rsq_LVF)],'Color','g')



