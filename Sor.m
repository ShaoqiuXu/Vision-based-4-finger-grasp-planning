function VTP=Sor(VTP0,Ver,Nj)
%����ʱ��˳��������Ӧ�����ڽڵ㣬������һλ��ʹ��β������
%���룻VTP0:���ڵ����ꣻVer���������ꣻNj�����ڵ����
Un=Ver/(Ver'*Ver)^0.5; E3=eye(3); %Un:����Ver�ĵ�λ��������
Vtp1=(E3-Un*Un')*(VTP0(:,1)-Ver);%��(VTP0(:,1)-Ver)����UnΪ��������ƽ�����ͶӰ,Vtp1ΪͶӰ����
Tpx=Vtp1/(Vtp1'*Vtp1)^0.5;%Tpx��Vtp1�ĵ�λ��������
Tpy=cross(Un,Tpx);%Tpy����Tpx��ͬһƽ���ϣ���Tpx��ֱ������
for i=1:Nj-1
    Vtp=(E3-Un*Un')*(VTP0(:,i+1)-Ver); %ԭʼ�ĵ�һ�����ڵ���ƽ��ȥͶӰ
     tp=Vtp/(Vtp'*Vtp)^0.5;
     xx=tp'*Tpx;
     yy=tp'*Tpy;%���԰�Tpx��Tpy�������������x���y��
     ph=atan2(yy,xx);%ͨ������tp��Tpx�Լ�Tpy����ʼ��׼���ļн�������
     if ph<0
         ph=ph+2*pi;%������0��2pi����
     end
     phi(i)=ph;%phi��Ver���������ڵ����һ�����ڵ�ļн�
end
[Phi,IndP]=sort(phi);%IndP:������
 VTP(:,1)=VTP0(:,1);%��һ����������Ϊ��׼��δ��������
for j=1:Nj-1
    VTP(:,j+1)=VTP0(:,IndP(j)+1);%�������������IndP(j)+1��Ԫ�ط���j+1����+1����Ϊ��һ������������
end
VTP=[VTP,VTP(:,1)];%�ѵ�һ�и���һ��������