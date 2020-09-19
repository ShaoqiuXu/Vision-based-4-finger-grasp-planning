function Adj2=Adj2(R,P)
%返回二维R、P转化成的旋量矩阵
Adj2=[R zeros(2,1);
    [-P(2) P(1)]*R 1];
end