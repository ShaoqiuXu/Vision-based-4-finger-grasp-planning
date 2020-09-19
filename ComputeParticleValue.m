function measure=ComputeParticleValue(para,position)
t1=position(1);
t2=position(2);
t3=position(3);
t4=position(4);
c=para.c;
c_real=para.c_real;
c_imag=para.c_imag;
n=para.n;
measure=TtoQlrw(t1,t2,t3,t4,c,c_real,c_imag,n);
end