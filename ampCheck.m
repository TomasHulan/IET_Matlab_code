function [f,X,T] = ampCheck(p)
%vyberie pri kmitan� body, kde m� funkcia
%lok�lne maximum
%ekvivalentom je funkcia localMax
%p - vektor, harmonick� priebeh
%f - hodnoty vystupnych bodov, X - indexy lokalnych maxim
%T - perioda maxim
n = length(p);

pR = p(3);%bod napravo
pL = p(1);%bod na�avo
m = 0;%index posledn�ho maxima
T = [];
f = [];
X=[];%indexy max�m

j = 1;
i=2;
while i<n
    pL = p(i-1);
    pR = p(i+1);
    if pL<p(i) && pR<p(i)
        f(j) = p(i);
        T(j) = i-m;
        X(j) = i;
        m = i;
        i = i+2;
        j = j+1;
    else
        i=i+1;
    end
end

%vymaza?:-----------------------------------------------------------------
% for i = 2:n-1
%     if pL < p(i) && pR < p(i)
%         f(j) = p(i);  
%         pL = p(i);
%         if i<n-1
%             pR = p(i+2);
%         end
%         T(j) = i-m;
%         X(j) = i;
%         j = j+1;
%         m=i;
%     else
%         if i<n-1
%             pL = p(i);
%             pR = p(i+2);
%         end
%     end
% end
%--------------------------------------------------------------------------
if isempty(j)%ak sa nen�jde �iadne lok�lne maximum, prirad� sa hodnota prv�ho bodu
    f = p(1);
    T = n;
    X = 1;
end
T = round(mean(T));%priemern� rozostup max�m
end