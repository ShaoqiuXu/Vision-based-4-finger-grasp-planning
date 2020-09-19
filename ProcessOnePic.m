function results=ProcessOnePic(im_center,im)
%�ü���������
a=im_center(1);
b=im_center(2);
Xmin=max(0,a-100);
Ymin=max(0,b-100);
Xmax=min(size(im,2),Xmin+199);
Ymax=min(size(im,1),Ymin+199);
f_raw=imcrop(im,[Xmin,Ymin,Xmax-Xmin,Ymax-Ymin]);
%% ���㸵��Ҷ�����Ӳ���������ָ��
f_g=rgb2gray(f_raw);
f_g=imadjust(f_g);
h=fspecial('gaussian',3);
g=imfilter(f_g,h,'replicate');
g=im2bw(g,graythresh(g));
se=strel('disk',3');
g=imopen(g,se);
g=1-g;
b=boundaries(g);%ԭʼ�����㣨�߽�㣩
b=b{1};

%ע��boundary��������X��Y��ͼ���������෴�������ȡʱ��һ��Ϊy���ڶ���Ϊx
xn=b(:,2)+1i*b(:,1);%������ʽ
L=size(xn,1);%���������
Xk=fft(xn);%�Զ�����Ҷ�任�����㸵��Ҷ������

%��֤Ϊ����
if mod(size(Xk,1),2)==0
    Xk=[Xk;Xk(end,:)];
end

%���С��120�������ӣ�˵��δ��ȡ�������������м��㣬plot_flagΪ0������Ҳ����ͼ��Ϊ1������һ�ͼ
if size(Xk,1)<120
    results.plot_flag=0;
else
    results.plot_flag=1;
end

n=50;%��ȡ�ĸ���Ҷ�������(������50)
n=floor(min((size(Xk,1)-1)/2,50));%��ֹ������101��������,���Ĳ���Ϊ(size(Xk,1)-1)/2
c=zeros(2*n+1,1);%��fft�����貿����ȡ����
%%%%��Ҫ�ı任%%%%%
c(n+1:2*n+1,1)=Xk(1:n+1)*1/L;%��Ƶ��
c(1:n,1)=Xk(L-n+1:L)*1/L;%��Ƶ�ʣ���ת�������ǿ�����Ƶ��ת��
c_real=real(c);
c_imag=imag(c);%����x��y����


if results.plot_flag==1
    %% PSO�Ż�����
    [Qlrw_max,t1_index,t2_index,t3_index,t4_index]=PSO(c,c_real,c_imag,n);
    %��������λ��
    %����
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