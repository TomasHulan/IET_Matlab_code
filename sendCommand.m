function [respond flag] = sendCommand( object, command, data)
    flag = 0;
    respond=[];
    if ~isempty(object)
        if isempty(data)
            %vymazat buffer
            while get(object,'BytesAvailable')>0
                fread(object,1,'uchar');
            end
            fprintf(object,'%c',command);
            respond=fscanf(object);
            l=length(respond);
            respond=respond(length(command)+1:end-2);
            flag = 1;
            return
        end 
        for i=1:size(data,1)
            %vymazat buffer
            while get(object,'BytesAvailable')>0
                fread(object,1,'uchar');
            end
            command=sprintf(command,data(i,:)); %vysk˙saù pre NS:
            fprintf(object,'%c',command);
            if isempty(respond)
                respond=fscanf(object);
                l=length(respond);
    %             respond=respond(length(command)+1:end-2);
            else
                respondTemp=fscanf(object);
                l=length(respondTemp);
                respond(:,end+1)=respondTemp(length(command)+1:end-2);
            end
        end
        if isempty(respond)
            flag=0;
        else
            flag=1;
        end
        return
    else
        respond='';
        flag=1;
    end
end