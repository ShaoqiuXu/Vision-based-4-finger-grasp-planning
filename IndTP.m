 function [Ind_p0,NTp_p,Ind_m0,NTp_m]=IndTP(Ver,Ver_p,Ver_m,VTP,Nj,Jac)
%���ڹ�ϵVer_p=Ver+Jac;Ver_m=Ver-Jac
%VTP�ѵ�һ�и��Ƶ������Ϊ�˷����γɸ�����׶����ķ���
%��ⶥ��Ver�������ڵ��ָ�꼯
Tp_p=0;Tp_m=0;
NTp_p=[0;0;0]; NTp_m=[0;0;0];
for s=1:Nj%����s�����ڵ㣬����s���߽���
    DTp_1=VTP(:,s)-Ver; %�����ڵ��γɵĵ�s���߽���
    DTp_2=VTP(:,s+1)-Ver;
    %���䷨����,����ԭ�㷽��,û�п��������ϵ����ô��
    DTp=cross(DTp_1,DTp_2);
    DTp_p=Jac'*DTp;
    DTp_m=-DTp_p;
    if DTp_p>0
        %Ind_p����¼Ver_p�͸������������ϵ
        Ind_p(s)=1;%Ind_p(s):Ver_p���ڵ�s��ƽ���������ģ���Ϊ1����
        %Ip_p����¼Ver_p�����ӵ�
        Tp_p=[Tp_p,s,s+1];%Tp_p��Ver_p��������࣬��Ҫ��s��s+1�ŵ�����
    else
        Ind_p(s)=0;
    end
    if DTp_m>0
        %Ind_m����¼Ver_m�͸������������ϵ
        Ind_m(s)=1;%Ind_p(s):Ver_m���ڵ�s��ƽ���������ģ���Ϊ1��
        %Ip_m����¼Ver_m�����ӵ�
        Tp_m=[Tp_m,s,s+1];%Tp_m��Ver_m��������࣬��Ҫ��s��s+1�ŵ�����
    else
        Ind_m(s)=0;
    end
end
Tp_p(:,1)=[]; %������һ����Ԫ�أ�0��Ϊ�˳�ʼ�����õ�
Tp_m(:,1)=[]; 
%����������һλ�������һλ�ظ���������ΪVTP���һ����͵�һ��������ͬ��
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
%ȥ���ظ������Ķ�����Ŀ
Tp_p=unique(Tp_p); Np=length(Tp_p);
Tp_m=unique(Tp_m); Nm=length(Tp_m);
%NTp_p��Ver_p�����ӵ������
for i=1:Np
    NTp_p=[NTp_p,VTP(:,Tp_p(i))+Jac];
end
%NTp_m��Ver_m�����ӵ������
for i=1:Nm
    NTp_m=[NTp_m,VTP(:,Tp_m(i))-Jac];
end
%������һ����Ԫ�أ�0Ҳ��Ϊ�˳�ʼ�����õ�
NTp_p(:,1)=[];
NTp_m(:,1)=[];
%������������ۣ��ⲿ���ڲ��Լ�֮��
%Ind_p0=1��Ver_p�����б߽������ࣻInd_p0=0��Ver_p�����б߽�����ڲࣻInd_p0=-1��Ver_p�����б߽�����������
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