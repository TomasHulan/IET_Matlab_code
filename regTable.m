function TableRs = regTable( TableT )
    
    n=size(TableT,1);    
    if(~isempty(TableT))
        TableR=TableT(1,:);
        TableR=TableT(1,:);
        for i=2:n
            if (TableT(i,3)==0)
                if (TableR(i-1,2)>TableT(i,2))
                    TableR=[TableR;[-1*TableT(i,1),TableT(i,2),0]];
                else
                    TableR=[TableR;[TableT(i,1),TableT(i,2),0]];
                end
            else
                TableR=[TableR;[0,TableR(i-1,2),TableT(i,3)]];
            end
        end
        TableRs=TableR(1,:);
        row=1;
        for i=2:size(TableR,1)
            if ((TableR(i,1) == TableRs(row,1))&& ((TableR(i,3)==0)&& (TableR(i,3)==0)))
                TableRs(row,2)=TableR(i,2);
            elseif (((TableR(i,3)~=0) && TableR(i,1)==0)&& ((TableRs(row,3)~=0)  && TableR(i,1)==0))
                TableRs(row,3)=TableR(i,3)+TableRs(row,3);
            else
                TableRs=[TableRs;TableR(i,:)];
                row=row+1;
            end
        end
    else
        TableR=[];
    end
end

