 function [Ind_p0,NTp_p,Ind_m0,NTp_m]=IndTP(Ver,Ver_p,Ver_m,VTP,Nj,Jac)
%存在关系Ver_p=Ver+Jac;Ver_m=Ver-Jac
%VTP把第一列复制到最后，是为了方便形成各个棱锥的面的方程
%求解顶点Ver各个树节点的指标集
Tp_p=0;Tp_m=0;
NTp_p=[0;0;0]; NTp_m=[0;0;0];
for s=1:Nj%共有s个相邻点，就有s个边界面
    DTp_1=VTP(:,s)-Ver; %由树节点形成的第s个边界面
    DTp_2=VTP(:,s+1)-Ver;
    %求其法向量,背离原点方向,没有考虑在面上的情况么！
    DTp=cross(DTp_1,DTp_2);
    DTp_p=Jac'*DTp;
    DTp_m=-DTp_p;
    if DTp_p>0
        %Ind_p：记录Ver_p和各个面的内外侧关系
        Ind_p(s)=1;%Ind_p(s):Ver_p对于第s个平面是在外侧的（记为1）、
        %Ip_p：记录Ver_p的连接点
        Tp_p=[Tp_p,s,s+1];%Tp_p：Ver_p由于在外侧，需要和s和s+1号点连接
    else
        Ind_p(s)=0;
    end
    if DTp_m>0
        %Ind_m：记录Ver_m和各个面的内外侧关系
        Ind_m(s)=1;%Ind_p(s):Ver_m对于第s个平面是在外侧的（记为1）
        %Ip_m：记录Ver_m的连接点
        Tp_m=[Tp_m,s,s+1];%Tp_m：Ver_m由于在外侧，需要和s和s+1号点连接
    else
        Ind_m(s)=0;
    end
end
Tp_p(:,1)=[]; %舍弃第一个零元素，0是为了初始化设置的
Tp_m(:,1)=[]; 
%如果出现最后一位，则与第一位重复，这是因为VTP最后一个点和第一个点是相同的
MTp_p=length(Tp_p); 
if MTp_p~=0
    if Tp_p(MTp_p)==Nj+1
        Tp_p(MTp_p)=1;
    end
end
MTp_m=length(Tp_m); 
if MTp_m~=0
    if Tp_m(MTp_m)==Nj+1
        Tp_m(MTp_m)=1;
    end
end
%去掉重复计数的定点数目
Tp_p=unique(Tp_p); Np=length(Tp_p);
Tp_m=unique(Tp_m); Nm=length(Tp_m);
%NTp_p：Ver_p的连接点的坐标
for i=1:Np
    NTp_p=[NTp_p,VTP(:,Tp_p(i))+Jac];
end
%NTp_m：Ver_m的连接点的坐标
for i=1:Nm
    NTp_m=[NTp_m,VTP(:,Tp_m(i))-Jac];
end
%舍弃第一列零元素，0也是为了初始化设置的
NTp_p(:,1)=[];
NTp_m(:,1)=[];
%分三种情况讨论，外部，内部以及之间
%Ind_p0=1：Ver_p在所有边界面的外侧；Ind_p0=0：Ver_p在所有边界面的内侧；Ind_p0=-1：Ver_p在所有边界面有内有外
if Ind_p==1
    Ind_p0=1;
else if Ind_p==0
        Ind_p0=0;
    else
        Ind_p0=-1;
    end
end
if Ind_m==1
    Ind_m0=1;
else if Ind_m==0
        Ind_m0=0;
    else
        Ind_m0=-1;
    end
end        