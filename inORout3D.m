function [flag,min_dist]=inORout3D(Face,Vertex)
%判断原点是否在凸包内部，若在内部，求内切圆的半径
%如果原点不在凸包内部，那其一定在边界上，则直接判断Tri中是否有
n=size(Face,1);%共n个平面
flag=1;
min_dist=10000;
for i=1:1:n
    %取每个面的前三个点构造平面方程
    x1=Vertex(Face(i,1),1);y1=Vertex(Face(i,1),2);z1=Vertex(Face(i,1),3);
    x2=Vertex(Face(i,2),1);y2=Vertex(Face(i,2),2);z2=Vertex(Face(i,2),3);
    x3=Vertex(Face(i,3),1);y3=Vertex(Face(i,3),2);z3=Vertex(Face(i,3),3);
    A(i) = (y2 - y1)*(z3 - z1) - (z2 - z1)*(y3 - y1);
    B(i) = (x3 - x1)*(z2 - z1) - (x2 - x1)*(z3 - z1);
    C(i) = (x2 - x1)*(y3 - y1) - (x3 - x1)*(y2 - y1);
    D(i) = -A(i)*x1-B(i)*y1-C(i)*z1;
    %平面方程为A(x-x1)+B(y-y1)+C(z-z1)=0，存储各个平面的参数
    if (x1==0&&y1==0&&z1==0)||(x2==0&&y2==0&&z2==0)
        flag=0;%原点在外部
    end
end
%计算以原点为圆心的内切圆半径
if flag==1
    for i=1:1:n
        %d=|Ax0+By0+Cz0+D|/sqrt(A^2+B^2+C^2)
        dist=abs(D(i))/sqrt(A(i)^2+B(i)^2+C(i)^2);
        if dist<min_dist
            min_dist=dist;
        end
    end
end

end