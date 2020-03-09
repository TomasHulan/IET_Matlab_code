function [ mat ] = separatestr( remain )
    segments=[];
    temp=[];
    while (~strcmp(remain,''))
        [token,remain] = strtok(remain, ';');
        remain2=token;
        while (~strcmp(remain2,''))
            [token2,remain2] = strtok(remain2, ':');
            temp=[temp str2num(token2)];
        end
        segments = [segments ; temp];
        temp=[];
    end
    mat=segments;
    for r=1:size(mat,1)
        if(mat(r,1)~=0)
            mat(r,3)=0;
        end
        mat(r,1)=abs(mat(r,1));
    end
end

