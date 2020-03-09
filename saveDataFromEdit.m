function data=saveDataFromEdit(data, edit)

if (or(isequal(get(edit,'String'),''),isempty(get(edit,'String'))))
    data=NaN;
else
    if (all(ismember(get(edit,'String'), '0123456789+-.eEdD')))
        data=str2num(get(edit,'String'));
    else
        set(edit,'String',strrep(get(edit,'String'),',','.'));
        if (all(ismember(get(edit,'String'), '0123456789+-.eEdD')))
            data=str2num(get(edit,'String'));
%         else
%             load(data,edit);
        end
    end
    if data<0
        data=-1*data;
%         load(data,edit);
    end
    if data<0.01
        data=0.01;
%         load(data,edit);
    end
    load(data,edit);
end

function load(data, edit)

if (isnan(data))
    set(edit,'String','');
else
    set(edit,'String',num2str(data));
end