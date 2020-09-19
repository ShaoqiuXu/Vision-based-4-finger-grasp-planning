function [Qlrw,t1_index,t2_index,t3_index,t4_index]=PSO(c,c_real,c_imag,n)
%根据PSO方法计算得到最优抓取位置
%非线性权重（目前最好）
%% 相关参数定义
c1=1.4962;
c2=1.4962;  
wmax=0.7298;
wmin=0.6;
MaxDT=200;      %% 最大迭代步数
D=4;           %% 粒子维度
N=300;         %% 粒子个数
para.c=c;
para.c_real=c_real;
para.c_imag=c_imag;
para.n=n;
%% 粒子位置和速度初始化
for i=1:N
     x(:,i)=rand(D,1);                 %% in [0,1]
     v(:,i)=(rand(D,1)-rand(D,1))/20; 
end

%% 进行粒子位置的优化
%第一次计算(初始化）
for i=1:N
    fl(i)=ComputeParticleValue(para,x(:,i)); %% fl：每个粒子的最好指标（初始化为初始指标）
    pb(:,i)=x(:,i);         %% pb：过去最好的粒子位置（初始化为最初位置) 
end

gb=x(:,1);%gd：全局最好的粒子位置（初始化为第一个粒子的位置）
fg=fl(1);%fg：全局最好的粒子的评价指标（初始化为第一个粒子的评价指标）

%第二次计算（找到第一次计算中的全局最优位置和全局最优指标）
for i=2:N
    if fl(i)>fg
        fg=fl(i); 
        gb=x(:,i);
    end
end

%进行粒子的移动
for t=1:MaxDT
    t
    w=-4*(wmax-wmin)*t^2/MaxDT^2+4*(wmax-wmin)*t/MaxDT+wmin;
    for i=1:N
        r1=random('unif',0,1); 
        r2=random('unif',0,1);
        v(:,i)=w*v(:,i)+c1*r1*(pb(:,i)-x(:,i))+c2*r2*(gb-x(:,i));
        x(:,i)=x(:,i)+v(:,i);
        %进行周期延拓，超出1或小于0的恢复至区间[0,1]
        %%%需要避免t出现相同的情况（未加）
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
    Pbt(:,t)=gb; %存储每次迭代后最优的全局位置
    Fbt(t)=fg; %存储每次迭代后最优的全局指标
end
Qlrw=Fbt(MaxDT);
t1_index=Pbt(1,MaxDT);
t2_index=Pbt(2,MaxDT);
t3_index=Pbt(3,MaxDT);
t4_index=Pbt(4,MaxDT);
end