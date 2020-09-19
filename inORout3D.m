function [flag,min_dist]=inORout3D(Face,Vertex)
%�ж�ԭ���Ƿ���͹���ڲ��������ڲ���������Բ�İ뾶
%���ԭ�㲻��͹���ڲ�������һ���ڱ߽��ϣ���ֱ���ж�Tri���Ƿ���
n=size(Face,1);%��n��ƽ��
flag=1;
min_dist=10000;
for i=1:1:n
    %ȡÿ�����ǰ�����㹹��ƽ�淽��
    x1=Vertex(Face(i,1),1);y1=Vertex(Face(i,1),2);z1=Vertex(Face(i,1),3);
    x2=Vertex(Face(i,2),1);y2=Vertex(Face(i,2),2);z2=Vertex(Face(i,2),3);
    x3=Vertex(Face(i,3),1);y3=Vertex(Face(i,3),2);z3=Vertex(Face(i,3),3);
    A(i) = (y2 - y1)*(z3 - z1) - (z2 - z1)*(y3 - y1);
    B(i) = (x3 - x1)*(z2 - z1) - (x2 - x1)*(z3 - z1);
    C(i) = (x2 - x1)*(y3 - y1) - (x3 - x1)*(y2 - y1);
    D(i) = -A(i)*x1-B(i)*y1-C(i)*z1;
    %ƽ�淽��ΪA(x-x1)+B(y-y1)+C(z-z1)=0���洢����ƽ��Ĳ���
    if (x1==0&&y1==0&&z1==0)||(x2==0&&y2==0&&z2==0)
        flag=0;%ԭ�����ⲿ
    end
end
%������ԭ��ΪԲ�ĵ�����Բ�뾶
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