function [Qlrw,t1_index,t2_index,t3_index,t4_index]=PSO(c,c_real,c_imag,n)
%����PSO��������õ�����ץȡλ��
%������Ȩ�أ�Ŀǰ��ã�
%% ��ز�������
c1=1.4962;
c2=1.4962;  
wmax=0.7298;
wmin=0.6;
MaxDT=200;      %% ����������
D=4;           %% ����ά��
N=300;         %% ���Ӹ���
para.c=c;
para.c_real=c_real;
para.c_imag=c_imag;
para.n=n;
%% ����λ�ú��ٶȳ�ʼ��
for i=1:N
     x(:,i)=rand(D,1);                 %% in [0,1]
     v(:,i)=(rand(D,1)-rand(D,1))/20; 
end

%% ��������λ�õ��Ż�
%��һ�μ���(��ʼ����
for i=1:N
    fl(i)=ComputeParticleValue(para,x(:,i)); %% fl��ÿ�����ӵ����ָ�꣨��ʼ��Ϊ��ʼָ�꣩
    pb(:,i)=x(:,i);         %% pb����ȥ��õ�����λ�ã���ʼ��Ϊ���λ��) 
end

gb=x(:,1);%gd��ȫ����õ�����λ�ã���ʼ��Ϊ��һ�����ӵ�λ�ã�
fg=fl(1);%fg��ȫ����õ����ӵ�����ָ�꣨��ʼ��Ϊ��һ�����ӵ�����ָ�꣩

%�ڶ��μ��㣨�ҵ���һ�μ����е�ȫ������λ�ú�ȫ������ָ�꣩
for i=2:N
    if fl(i)>fg
        fg=fl(i); 
        gb=x(:,i);
    end
end

%�������ӵ��ƶ�
for t=1:MaxDT
    t
    w=-4*(wmax-wmin)*t^2/MaxDT^2+4*(wmax-wmin)*t/MaxDT+wmin;
    for i=1:N
        r1=random('unif',0,1); 
        r2=random('unif',0,1);
        v(:,i)=w*v(:,i)+c1*r1*(pb(:,i)-x(:,i))+c2*r2*(gb-x(:,i));
        x(:,i)=x(:,i)+v(:,i);
        %�����������أ�����1��С��0�Ļָ�������[0,1]
        %%%��Ҫ����t������ͬ�������δ�ӣ�
        for col=1:1:size(x,2)
            for row=1:1:size(x,1)
                if x(row,col)<0
                    x(row,col)=x(row,col)-floor(x(row,col));
                elseif x(row,col)>1 
                    x(row,col)=x(row,col)-floor(x(row,col));
                end          
            end
        end
        ftemp=ComputeParticleValue(para,x(:,i));     
        if ftemp>fl(i)         %% compare to the past best
            fl(i)=ftemp;       %% if so, update the best 
            pb(:,i)=x(:,i);
        end
        if ftemp>fg            %% compare to the global best
            fg=ftemp;          %% if so, update the best 
            gb=x(:,i);
        end   
    end
    Pbt(:,t)=gb; %�洢ÿ�ε��������ŵ�ȫ��λ��
    Fbt(t)=fg; %�洢ÿ�ε��������ŵ�ȫ��ָ��
end
Qlrw=Fbt(MaxDT);
t1_index=Pbt(1,MaxDT);
t2_index=Pbt(2,MaxDT);
t3_index=Pbt(3,MaxDT);
t4_index=Pbt(4,MaxDT);
end