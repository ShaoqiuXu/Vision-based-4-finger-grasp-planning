function Adj2=Adj2(R,P)
%���ض�άR��Pת���ɵ���������
Adj2=[R zeros(2,1);
    [-P(2) P(1)]*R 1];
end