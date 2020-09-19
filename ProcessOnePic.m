function results=ProcessOnePic(im_center,im)
%裁剪中心区域
a=im_center(1);
b=im_center(2);
Xmin=max(0,a-100);
Ymin=max(0,b-100);
Xmax=min(size(im,2),Xmin+199);
Ymax=min(size(im,1),Ymin+199);
f_raw=imcrop(im,[Xmin,Ymin,Xmax-Xmin,Ymax-Ymin]);
%% 计算傅里叶描述子并计算评价指标
f_g=rgb2gray(f_raw);
f_g=imadjust(f_g);
h=fspecial('gaussian',3);
g=imfilter(f_g,h,'replicate');
g=im2bw(g,graythresh(g));
se=strel('disk',3');
g=imopen(g,se);
g=1-g;
b=boundaries(g);%原始采样点（边界点）
b=b{1};

%注意boundary的坐标轴X、Y与图像坐标轴相反，因此提取时第一列为y，第二列为x
xn=b(:,2)+1i*b(:,1);%复数形式
L=size(xn,1);%采样点个数
Xk=fft(xn);%自动傅里叶变换，计算傅里叶描述子

%保证为奇数
if mod(size(Xk,1),2)==0
    Xk=[Xk;Xk(end,:)];
end

%如果小于120个描述子，说明未提取到轮廓，不进行计算，plot_flag为0不计算也不画图，为1则计算且画图
if size(Xk,1)<120
    results.plot_flag=0;
else
    results.plot_flag=1;
end

n=50;%提取的傅里叶级数层次(正负各50)
n=floor(min((size(Xk,1)-1)/2,50));%防止不存在101个特征点,最多的层数为(size(Xk,1)-1)/2
c=zeros(2*n+1,1);%将fft中所需部分提取出来
%%%%重要的变换%%%%%
c(n+1:2*n+1,1)=Xk(1:n+1)*1/L;%正频率
c(1:n,1)=Xk(L-n+1:L)*1/L;%负频率（反转，不可是看作高频正转）
c_real=real(c);
c_imag=imag(c);%便于x和y的求导


if results.plot_flag==1
    %% PSO优化计算
    [Qlrw_max,t1_index,t2_index,t3_index,t4_index]=PSO(c,c_real,c_imag,n);
    %画出最优位置
    %坐标
    xt1=0;
    xt2=0;
    xt3=0;
    xt4=0;
    for j=1:2*n+1
        nn=j-n-1;
        
        xt1=xt1+c(j)*exp(nn*2*pi*1i*t1_index);
        xt2=xt2+c(j)*exp(nn*2*pi*1i*t2_index);
        xt3=xt3+c(j)*exp(nn*2*pi*1i*t3_index);
        xt4=xt4+c(j)*exp(nn*2*pi*1i*t4_index);
    end
    x1_plot=real(xt1);
    y1_plot=imag(xt1);
    x2_plot=real(xt2);
    y2_plot=imag(xt2);
    x3_plot=real(xt3);
    y3_plot=imag(xt3);
    x4_plot=real(xt4);
    y4_plot=imag(xt4);
    
    coord=[x1_plot,y1_plot;
        x2_plot,y2_plot;
        x3_plot,y3_plot;
        x4_plot,y4_plot];
    t_all=[t1_index;t2_index;t3_index;t4_index];
    
    results.im=f_raw;
    results.coord=coord;
    results.t_all=t_all;
    results.meas=Qlrw_max;
    
    results.c=c;
    results.c_real=c_real;
    results.c_imag=c_imag;
    results.b=b;
else
    results.im=f_raw;
    results.coord=zeros(4,2);
    results.t_all=zeros(4,1);
    results.meas=0;
    
    results.c=c;
    results.c_real=c_real;
    results.c_imag=c_imag;
    results.b=b;
end


end