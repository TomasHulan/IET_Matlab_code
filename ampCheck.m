function [f,X,T] = ampCheck(p)
%vyberie pri kmitaní body, kde má funkcia
%lokálne maximum
%ekvivalentom je funkcia localMax
%p - vektor, harmonický priebeh
%f - hodnoty vystupnych bodov, X - indexy lokalnych maxim
%T - perioda maxim
n = length(p);

pR = p(3);%bod napravo
pL = p(1);%bod na¾avo
m = 0;%index posledného maxima
T = [];
f = [];
X=[];%indexy maxím

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
if isempty(j)%ak sa nenájde žiadne lokálne maximum, priradí sa hodnota prvého bodu
    f = p(1);
    T = n;
    X = 1;
end
T = round(mean(T));%priemerný rozostup maxím
end