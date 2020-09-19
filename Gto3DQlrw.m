function Qlrw=Gto3DQlrw(G,c_real,c_imag,n)%������Ҫ����ת�������������Ҫ����Ҷ������
%% �����������rou
mr2=0;%��΢Ԫת������֮��
%����
x_center=c_real(n+1);
y_center=c_imag(n+1);
for tt=0:1:500-1
    t=tt/500;
    xt_x=0;
    xt_y=0;
    for j=1:2*n+1
        nn=j-n-1;%��-n��n
        xt_x=xt_x+c_real(j)*cos(nn*2*pi*t)-c_imag(j)*sin(nn*2*pi*t);
        xt_y=xt_y+c_real(j)*sin(nn*2*pi*t)+c_imag(j)*cos(nn*2*pi*t);
    end
    mr2=mr2+((xt_x-x_center)^2+(xt_y-y_center)^2)/500;
end
rou=sqrt(mr2);
%% ����ץȡ����Qlrw,���ñ߽��ƽ��㷨
[Jaco0,NVer,NTP,JCen]=IntiConvexHull(G,rou);
NVer00=NVer;NTP00=NTP;Jaco00=Jaco0;
Jaco=Jaco0(:,1:4);
dim=length(Jaco);
%NVerΪ��ǰ���Ķ��㼯��NTPΪ��֮���Ӧ�Ķ����ڵ㼯����ʼʱΪ8ά
for i=4:dim
    Nv=length(NVer); %Nv����ǰpolytope�Ķ�����
    Jac=Jaco(:,i);%Jac����i����Ҫ����������
    Nv0=Nv; %ѭ��ʽ���ÿ����»�ȡ�Ķ���
    NVer0=NVer;%NVer����ǰ���ж��������
    NTP0=NTP;%NTP����ǰ���ж�������ڵ�����꣬3*3��ÿһ����һ����
    for j=1:Nv0
        %Ver:��j�����㣻Ver_p/Ver_m�����ܵ��¶���
        Ver=NVer0{j}; Ver_p=Ver+Jac; Ver_m=Ver-Jac; %�����¶���,p=plus;m=minus
        VTP0= NTP0{j};%VTP0��Ver�����ڶ���������
        Nj=length(VTP0); %Nj��Ver�����ڶ�����tree-point
        
        %�����ڵ���������������������һ��
        VTP=Sor(VTP0,Ver,Nj); %VTP�������Ver�����ڵ㣬���һ�����һ����ͬ
        
        %��ȡ���������ڵ��0-1ָ�꼯,�������ڲ�ֱ�Ӹ������ڵ㣬��������Ver_p��Ver_m
        %��һ������������������
        [Ind_p,Tp_p,Ind_m,Tp_m]=IndTP(Ver,Ver_p,Ver_m,VTP,Nj,Jac);
        %ֱ�ӵõ�����֮��Ķ��㼯�������ڵ㼯
        %�پ���һ���жϵõ�
        if Ind_p==1 && Ind_m==0
            %���Ver_p�����ⲿ��Ver_m�����ڲ����ǾͰѵ�j������Ver_p���棬�����ڵ������NTPҲҪ�ı�
            NVer{j}=Ver_p;
            NTP{j}= Tp_p;
        else if Ind_m==1 && Ind_p==0
                %���Ver_m�����ⲿ��Ver_p�����ڲ����ǾͰѵ�j������Ver_m���棬�����ڵ������NTPҲҪ�ı�
                NVer{j}=Ver_m;
                NTP{j}= Tp_m;
            else if Ind_p==-1 && Ind_m==-1
                    %���Ver_p�������⣬Ver_mҲ��������
                    %��j������Ver_p���棬�����ڶ������ԭ����Ver�Ĳ������ڵ�Tp_p��������Ver_m
                    %������Nv+1���㣬ΪVer_m�������ڶ������ԭ����Ver�Ĳ������ڵ�Tp_m��������Ver_p
                    Nv=Nv+1;
                    NVer{j}=Ver_p;
                    NTP{j}=[Tp_p,Ver_m];
                    NVer{Nv}=Ver_m;
                    NTP{Nv}=[Tp_m,Ver_p];
                end
            end
        end
        %Ver_p��Ver_m�ǻ����ģ���˲�����ֶ�Ϊ1��Ϊ0
    end
end


for k=1:Nv
    MVer(:,k)=NVer{k};%MVer:NVerת��Ϊ����Ľ����3��Nv�У�ÿһ����һ����������
end
k0=0;

%�Դ˴��ƽ���ĵ���д���
for k=1:Nv
    Ver_k=NVer{k};%Ver_k����k������
    NTP_k=NTP{k};%NTP_k����k����������ڵ�
    Nk=length(NTP_k);%Nk����k����������ڵ�ĸ���
    NTP_k=Sor(NTP_k,Ver_k,Nk);%��NTP_k����ʱ�����򣬲��ҽ���һ�и��������һ��
    [tf,loc]=ismember(NTP_k',MVer','rows');
    %ismember(A,B,'rows') �� A �� B �е�ÿһ����Ϊһ��ʵ�壬�� A �е���Ҳ������ B ��ʱ�������ذ����߼�ֵ 1 (true) ���������������е�����λ�ý������߼�ֵ 0 (false)��
    %�жϵ�k����������ڵ������ж����е�����
    %tf��ʾ��MVer'���Ƿ����NTP_k��
    %loc��ʾNTP_k'��ÿһ����MVer'�е�λ��
    for k1=1:Nk
        k0=k0+1;
        NTP_k1=NTP_k(:,k1);   [tf1,loc1]=ismember(NTP_k1',MVer','rows');
        NTP_k2=NTP_k(:,k1+1); [tf2,loc2]=ismember(NTP_k2',MVer','rows');
        %NTP_k1��NTP_k2��Ver_k���������������ڵ�
        %loc1��loc2��NTP_k1��NTP_k2�����ж���MVer�еı��
        VTP_k1=NTP{loc1}; [tf01,ind1]=ismember(VTP_k1',MVer','rows');
        VTP_k2=NTP{loc2}; [tf02,ind2]=ismember(VTP_k2',MVer','rows');
        %VTP_k1��VTP_k2�ֱ���NTP_k1��NTP_k2���������ڵ�
        %ind1��ind2��VTP_k1��VTP_k2�����ж���MVer�еı��
        ind1(ind1==k)=[];
        ind2(ind2==k)=[];
        %ɾ��Ver_k�ı��
        ind0=intersect(ind1,ind2);
        Mat(k0,:)=[k,loc1,ind0,loc2];
        %Mat�洢����һ���ı��ΰ�˳�����е��ĸ�����
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
% %cdat:��һ�����z�����С����Ϊ��ɫֵ
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


%�޷��ֿ����ⷽ������������Ϊ0����ƽ��
[flag,min_dist]=inORout3D(Mat0,MVer_plot);

if flag ==1
    Qlrw=min_dist;
    %�������������
%     sphere_r=Qlrw;
%     [sphere_x,sphere_y,sphere_z]=sphere(20);
%     mesh(sphere_r*sphere_x,sphere_r*sphere_y,sphere_r*sphere_z,'FaceAlpha',0.5);
%     plot3(0,0,0,'r.','markersize',20);
%     hold off;
else
    Qlrw=0;
end

end