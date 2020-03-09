function T=TempProgPlot(handles,Prog)
plot(handles.axes2,Prog(:,1),Prog(:,2),'Color',[0 0 0]);
axes(handles.axes2);
xlabel('Time [min]');
ylabel('Temperature [°C]');
box(handles.axes2,'on');
if (max(Prog(:,2)>0))
    set(handles.axes2,'XGrid','on','XMinorGrid','on','XMinorTick','on','YGrid','on',...
    'YMinorGrid','on','YMinorTick','on','YLim',[0,max(Prog(:,2))*1.1],'XLim',[0,max(Prog(:,1))*1.05]);
    S=max(Prog(:,1))*60;
    formatOut='dd.mm.yyyy HH:MM';
    T=datenum(datestr(S/86400,formatOut),formatOut);
    Tt=datenum(now);
    Tc=datestr(Tt+T,formatOut);
    set(handles.text19,'String',Tc)
else 
    set(handles.axes2,'XGrid','on','XMinorGrid','on','XMinorTick','on','YGrid','on',...
    'YMinorGrid','on','YMinorTick','on','YLim',[0,1],'XLim',[0,1]);
    set(handles.text19,'String','')
end

