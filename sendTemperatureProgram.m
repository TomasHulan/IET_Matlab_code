function [ output_args ] = sendTemperatureProgram( s,SData )
if ~isempty(SData.TableT)
    TableR=regTable(SData.TableT);
    n=size(TableR,1);
    if (n>0 && ~isempty(s))
        flag=0;
        w = waitbar(0,'Temperature program','Name','Save');

        for i=1:n
            while flag~=1
                command='NS:%.1f:%.1f:%.1f';
                [req flag]=sendCommand(s,command,TableR(i,:));
            end
%             input=sprintf(command,TableR(i,:));
            if(TableR(i,1)~=0 && TableR(i,3)==0)
                if (i==1)
                    calc=abs((str2num(sendCommand(s,'AT:',[]))-TableR(i,2))/TableR(i,1));
                else
                    calc=abs((TableR(i-1,2)-TableR(i,2))/TableR(i,1));
                end
            else
                calc=TableR(i,3);
            end
            input=sprintf(command,[TableR(i,1:2),calc]);
            output = cellstr(req);
            output=output{1};
%             if (strcmp(input,output))
%                 output
%             end
            flag=0;
            waitbar(i/n,w,'Temperature program');
        end
        waitbar(1,w,'Complete');
        close(w)
        [req,flag]=sendCommand(s,'CP:',[]);
    end
end
end

