function val = numericInput(handle)
    val=get(handles,'String');
    val=str2num(strrep(val,',','.'));
    if ~isempty(val)
        set(handle,'String',get(handle,'UserData'));
    else
        set(handle,'String',num2str(val));
    end
end