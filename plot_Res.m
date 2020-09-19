function plot_Res(plot_para,results)
if results.plot_flag==1
    
    %��ԭͼ�ϻ�
    imshow(results.im);
    hold on;
    p1=results.coord(1,:);
    p2=results.coord(2,:);
    p3=results.coord(3,:);
    p4=results.coord(4,:);
    plot(p1(1),p1(2),'r.','markersize',15);
    text(p1(1)+5,p1(2)+5,'1');
    plot(p2(1),p2(2),'r.','markersize',15);
    text(p2(1)+5,p2(2)+5,'2');
    plot(p3(1),p3(2),'r.','markersize',15);
    text(p3(1)+5,p3(2)+5,'3');
    plot(p4(1),p4(2),'r.','markersize',15);
    text(p4(1)+5,p4(2)+5,'4');
    axis ij;%��ͼ����ϵ�Ͷ�ͼ����ϵ�Ĳ�ͬ
    axis square;
    axis on;
    hold off;
    saveas(gcf,[plot_para.save_pic_dir,results.frame_name(1:8),'_result.png']);
    
    %��txt��¼�ĸ�tֵ��ָ��
    t1=results.t_all(1);
    t2=results.t_all(2);
    t3=results.t_all(3);
    t4=results.t_all(4);
    meas=results.meas;
    res_save=[t1;t2;t3;t4;meas];%ǰ4��Ϊt�����1��Ϊָ��
    save([plot_para.save_res_dir, results.frame_name(1:8),'_result.mat'], 'res_save');
    
    %��txt��¼ͼ���Ӧ�ĸ���Ҷ������
    c_save=results.c;
    save([plot_para.save_res_dir, results.frame_name(1:8),'_c.mat'], 'c_save');
    creal_save=results.c_real;
    save([plot_para.save_res_dir, results.frame_name(1:8),'_creal.mat'], 'creal_save');
    cimag_save=results.c_imag;
    save([plot_para.save_res_dir, results.frame_name(1:8),'_cimag.mat'], 'cimag_save');
end

end