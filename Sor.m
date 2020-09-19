function VTP=Sor(VTP0,Ver,Nj)
%按逆时针顺序排列相应的相邻节点，并增加一位以使得尾首相连
%输入；VTP0:相邻点坐标；Ver：顶点坐标；Nj：相邻点个数
Un=Ver/(Ver'*Ver)^0.5; E3=eye(3); %Un:顶点Ver的单位方向向量
Vtp1=(E3-Un*Un')*(VTP0(:,1)-Ver);%把(VTP0(:,1)-Ver)向以Un为法向量的平面进行投影,Vtp1为投影向量
Tpx=Vtp1/(Vtp1'*Vtp1)^0.5;%Tpx：Vtp1的单位方向向量
Tpy=cross(Un,Tpx);%Tpy：与Tpx在同一平面上，与Tpx垂直的向量
for i=1:Nj-1
    Vtp=(E3-Un*Un')*(VTP0(:,i+1)-Ver); %原始的第一个树节点向平面去投影
     tp=Vtp/(Vtp'*Vtp)^0.5;
     xx=tp'*Tpx;
     yy=tp'*Tpy;%可以把Tpx和Tpy看作是坐标轴的x轴和y轴
     ph=atan2(yy,xx);%通过计算tp和Tpx以及Tpy（初始标准）的夹角来排序
     if ph<0
         ph=ph+2*pi;%调整至0到2pi区间
     end
     phi(i)=ph;%phi：Ver的其余相邻点与第一个相邻点的夹角
end
[Phi,IndP]=sort(phi);%IndP:排序结果
 VTP(:,1)=VTP0(:,1);%第一个向量，作为基准，未参与排序
for j=1:Nj-1
    VTP(:,j+1)=VTP0(:,IndP(j)+1);%输出排序结果，第IndP(j)+1的元素放在j+1处，+1是因为第一个不参与排序
end
VTP=[VTP,VTP(:,1)];%把第一列复制一遍放在最后