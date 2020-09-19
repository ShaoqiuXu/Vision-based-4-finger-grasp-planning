function Qlrw=TtoQlrw(t1,t2,t3,t4,c,c_real,c_imag,n)
%根据傅里叶描述子和四个点的t，计算抓取性能Qlrw
%坐标
xt1=0;
xt1_x=0;
xt1_y=0;
xt2=0;
xt2_x=0;
xt2_y=0;
xt3=0;
xt3_x=0;
xt3_y=0;
xt4=0;
xt4_x=0;
xt4_y=0;
%导数
dxdt1=0;
dydt1=0;
dxdt2=0;
dydt2=0;
dxdt3=0;
dydt3=0;
dxdt4=0;
dydt4=0;

for j=1:2*n+1
    nn=j-n-1;%从-n到n
    
    xt1=xt1+c(j)*exp(nn*2*pi*1i*t1);
    xt1_x=xt1_x+c_real(j)*cos(nn*2*pi*t1)-c_imag(j)*sin(nn*2*pi*t1);
    xt1_y=xt1_y+c_real(j)*sin(nn*2*pi*t1)+c_imag(j)*cos(nn*2*pi*t1);
    dxdt1=dxdt1-c_real(j)*nn*2*pi*sin(nn*2*pi*t1)-c_imag(j)*nn*2*pi*cos(nn*2*pi*t1);
    dydt1=dydt1+c_real(j)*nn*2*pi*cos(nn*2*pi*t1)-c_imag(j)*nn*2*pi*sin(nn*2*pi*t1);
    
    xt2=xt2+c(j)*exp(nn*2*pi*1i*t2);
    xt2_x=xt2_x+c_real(j)*cos(nn*2*pi*t2)-c_imag(j)*sin(nn*2*pi*t2);
    xt2_y=xt2_y+c_real(j)*sin(nn*2*pi*t2)+c_imag(j)*cos(nn*2*pi*t2);
    dxdt2=dxdt2-c_real(j)*nn*2*pi*sin(nn*2*pi*t2)-c_imag(j)*nn*2*pi*cos(nn*2*pi*t2);
    dydt2=dydt2+c_real(j)*nn*2*pi*cos(nn*2*pi*t2)-c_imag(j)*nn*2*pi*sin(nn*2*pi*t2);
    
    xt3=xt3+c(j)*exp(nn*2*pi*1i*t3);
    xt3_x=xt3_x+c_real(j)*cos(nn*2*pi*t3)-c_imag(j)*sin(nn*2*pi*t3);
    xt3_y=xt3_y+c_real(j)*sin(nn*2*pi*t3)+c_imag(j)*cos(nn*2*pi*t3);
    dxdt3=dxdt3-c_real(j)*nn*2*pi*sin(nn*2*pi*t3)-c_imag(j)*nn*2*pi*cos(nn*2*pi*t3);
    dydt3=dydt3+c_real(j)*nn*2*pi*cos(nn*2*pi*t3)-c_imag(j)*nn*2*pi*sin(nn*2*pi*t3);
        
    xt4=xt4+c(j)*exp(nn*2*pi*1i*t4);
    xt4_x=xt4_x+c_real(j)*cos(nn*2*pi*t4)-c_imag(j)*sin(nn*2*pi*t4);
    xt4_y=xt4_y+c_real(j)*sin(nn*2*pi*t4)+c_imag(j)*cos(nn*2*pi*t4);
    dxdt4=dxdt4-c_real(j)*nn*2*pi*sin(nn*2*pi*t4)-c_imag(j)*nn*2*pi*cos(nn*2*pi*t4);
    dydt4=dydt4+c_real(j)*nn*2*pi*cos(nn*2*pi*t4)-c_imag(j)*nn*2*pi*sin(nn*2*pi*t4);
end
x1_plot=real(xt1);
y1_plot=imag(xt1);
x2_plot=real(xt2);
y2_plot=imag(xt2);
x3_plot=real(xt3);
y3_plot=imag(xt3);
x4_plot=real(xt4);
y4_plot=imag(xt4);

%重心位置
x_center=real(c(n+1));
y_center=imag(c(n+1));

%计算旋转矩阵
e1=[1;0];e2=[0;1];%固定基向量
e11=[dxdt1;dydt1]/norm([dxdt1;dydt1]);
e12=[-dydt1;dxdt1]/norm([-dydt1;dxdt1]);
R1=[e11'*e1 e12'*e1;
    e11'*e2 e12'*e2];

e21=[dxdt2;dydt2]/norm([dxdt2;dydt2]);
e22=[-dydt2;dxdt2]/norm([-dydt2;dxdt2]);
R2=[e21'*e1 e22'*e1;
    e21'*e2 e22'*e2];

e31=[dxdt3;dydt3]/norm([dxdt3;dydt3]);
e32=[-dydt3;dxdt3]/norm([-dydt3;dxdt3]);
R3=[e31'*e1 e32'*e1;
    e31'*e2 e32'*e2];

e41=[dxdt4;dydt4]/norm([dxdt4;dydt4]);
e42=[-dydt4;dxdt4]/norm([-dydt4;dxdt4]);
R4=[e41'*e1 e42'*e1;
    e41'*e2 e42'*e2];

%计算相对于重心的位置
PC1=[x1_plot;y1_plot]-[x_center;y_center];
PC2=[x2_plot;y2_plot]-[x_center;y_center];
PC3=[x3_plot;y3_plot]-[x_center;y_center];
PC4=[x4_plot;y4_plot]-[x_center;y_center];

%计算抓取映射矩阵G
Base_f=[0;1;0];%无摩擦点接触力旋量基
G1=Adj2(R1,PC1)*Base_f;
G2=Adj2(R2,PC2)*Base_f;
G3=Adj2(R3,PC3)*Base_f;
G4=Adj2(R4,PC4)*Base_f;
G=[G1 G2 G3 G4];

%指标7：对f进行模长限制，能抵抗的最大任意方向外力
Qlrw=Gto3DQlrw(G,c_real,c_imag,n);

end