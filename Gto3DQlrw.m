function Qlrw=Gto3DQlrw(G,c_real,c_imag,n)%由于需要计算转动惯量，因此需要傅里叶描述子
%% 计算比例因子rou
mr2=0;%各微元转动惯量之和
%重心
x_center=c_real(n+1);
y_center=c_imag(n+1);
for tt=0:1:500-1
    t=tt/500;
    xt_x=0;
    xt_y=0;
    for j=1:2*n+1
        nn=j-n-1;%从-n到n
        xt_x=xt_x+c_real(j)*cos(nn*2*pi*t)-c_imag(j)*sin(nn*2*pi*t);
        xt_y=xt_y+c_real(j)*sin(nn*2*pi*t)+c_imag(j)*cos(nn*2*pi*t);
    end
    mr2=mr2+((xt_x-x_center)^2+(xt_y-y_center)^2)/500;
end
rou=sqrt(mr2);
%% 计算抓取评价Qlrw,采用边界推进算法
[Jaco0,NVer,NTP,JCen]=IntiConvexHull(G,rou);
NVer00=NVer;NTP00=NTP;Jaco00=Jaco0;
Jaco=Jaco0(:,1:4);
dim=length(Jaco);
%NVer为当前步的顶点集，NTP为与之相对应的顶点邻点集，初始时为8维
for i=4:dim
    Nv=length(NVer); %Nv：当前polytope的顶点数
    Jac=Jaco(:,i);%Jac：第i个需要新增的向量
    Nv0=Nv; %循环式不用考虑新获取的顶点
    NVer0=NVer;%NVer：当前所有顶点的坐标
    NTP0=NTP;%NTP：当前所有顶点的相邻点的坐标，3*3，每一列是一个点
    for j=1:Nv0
        %Ver:第j个顶点；Ver_p/Ver_m：可能的新顶点
        Ver=NVer0{j}; Ver_p=Ver+Jac; Ver_m=Ver-Jac; %可能新顶点,p=plus;m=minus
        VTP0= NTP0{j};%VTP0：Ver的相邻顶顶点坐标
        Nj=length(VTP0); %Nj：Ver的相邻顶点数tree-point
        
        %对树节点进行排序，且在最后增加了一列
        VTP=Sor(VTP0,Ver,Nj); %VTP：排序后Ver的相邻点，最后一列与第一列相同
        
        %获取各顶点树节点的0-1指标集,可在其内部直接更新树节点，分析计算Ver_p和Ver_m
        %用一个函数计算整个过程
        [Ind_p,Tp_p,Ind_m,Tp_m]=IndTP(Ver,Ver_p,Ver_m,VTP,Nj,Jac);
        %直接得到更新之后的顶点集及其树节点集
        %再经过一步判断得到
        if Ind_p==1 && Ind_m==0
            %如果Ver_p都在外部，Ver_m都在内部，那就把第j个点用Ver_p代替，其相邻点的坐标NTP也要改变
            NVer{j}=Ver_p;
            NTP{j}= Tp_p;
        else if Ind_m==1 && Ind_p==0
                %如果Ver_m都在外部，Ver_p都在内部，那就把第j个点用Ver_m代替，其相邻点的坐标NTP也要改变
                NVer{j}=Ver_m;
                NTP{j}= Tp_m;
            else if Ind_p==-1 && Ind_m==-1
                    %如果Ver_p有内有外，Ver_m也有内有外
                    %第j个点用Ver_p代替，其相邻顶点除了原顶点Ver的部分相邻点Tp_p，还包括Ver_m
                    %新增第Nv+1个点，为Ver_m，其相邻顶点除了原顶点Ver的部分相邻点Tp_m，还包括Ver_p
                    Nv=Nv+1;
                    NVer{j}=Ver_p;
                    NTP{j}=[Tp_p,Ver_m];
                    NVer{Nv}=Ver_m;
                    NTP{Nv}=[Tp_m,Ver_p];
                end
            end
        end
        %Ver_p和Ver_m是互补的，因此不会出现都为1或都为0
    end
end


for k=1:Nv
    MVer(:,k)=NVer{k};%MVer:NVer转化为数组的结果，3行Nv列，每一列是一个顶点坐标
end
k0=0;

%对此次推进后的点进行处理
for k=1:Nv
    Ver_k=NVer{k};%Ver_k：第k个顶点
    NTP_k=NTP{k};%NTP_k：第k个顶点的相邻点
    Nk=length(NTP_k);%Nk：第k个顶点的相邻点的个数
    NTP_k=Sor(NTP_k,Ver_k,Nk);%对NTP_k按逆时针排序，并且将第一列复制至最后一列
    [tf,loc]=ismember(NTP_k',MVer','rows');
    %ismember(A,B,'rows') 将 A 和 B 中的每一行视为一个实体，当 A 中的行也存在于 B 中时，将返回包含逻辑值 1 (true) 的列向量。数组中的其他位置将包含逻辑值 0 (false)。
    %判断第k个顶点的相邻点在所有顶点中的坐标
    %tf表示在MVer'中是否存在NTP_k’
    %loc表示NTP_k'的每一行在MVer'中的位置
    for k1=1:Nk
        k0=k0+1;
        NTP_k1=NTP_k(:,k1);   [tf1,loc1]=ismember(NTP_k1',MVer','rows');
        NTP_k2=NTP_k(:,k1+1); [tf2,loc2]=ismember(NTP_k2',MVer','rows');
        %NTP_k1和NTP_k2是Ver_k的两个紧靠的相邻点
        %loc1和loc2是NTP_k1和NTP_k2在所有顶点MVer中的标号
        VTP_k1=NTP{loc1}; [tf01,ind1]=ismember(VTP_k1',MVer','rows');
        VTP_k2=NTP{loc2}; [tf02,ind2]=ismember(VTP_k2',MVer','rows');
        %VTP_k1和VTP_k2分别是NTP_k1和NTP_k2的所有相邻点
        %ind1和ind2是VTP_k1和VTP_k2在所有顶点MVer中的标号
        ind1(ind1==k)=[];
        ind2(ind2==k)=[];
        %删除Ver_k的标号
        ind0=intersect(ind1,ind2);
        Mat(k0,:)=[k,loc1,ind0,loc2];
        %Mat存储的是一个四边形按顺序排列的四个顶点
    end
end
Mat0=unique(Mat,'rows');
MVer0=MVer';
MVer_plot=MVer0+JCen';

% figure;
% zzm1=max(MVer0(:,3));
% zzm2=min(MVer0(:,3));
% dz=zzm1-zzm2;
% cdat=60*(MVer0(:,3)-zzm2)/dz;
% %cdat:归一化后的z方向大小，作为颜色值
% clf;
% p=patch('Faces',Mat0,'Vertices',MVer_plot);
% set(gca,'CLim',[0 60])
% set(p,'FaceColor','interp',...
%     'FaceVertexCData',cdat,...
%     'CDataMapping','scaled',...
%     'FaceAlpha',0.2,...
%     'EdgeColor','k',...
%     'LineWidth',1.25,...
%     'Marker','.',...
%     'MarkerSize',15);
% grid on;
% hold on;
% plot3(0,0,0,'r.','markersize',20);


%无法抵抗任意方向的力，则距离为0，不平衡
[flag,min_dist]=inORout3D(Mat0,MVer_plot);

if flag ==1
    Qlrw=min_dist;
    %画出最大内切球
%     sphere_r=Qlrw;
%     [sphere_x,sphere_y,sphere_z]=sphere(20);
%     mesh(sphere_r*sphere_x,sphere_r*sphere_y,sphere_r*sphere_z,'FaceAlpha',0.5);
%     plot3(0,0,0,'r.','markersize',20);
%     hold off;
else
    Qlrw=0;
end

end