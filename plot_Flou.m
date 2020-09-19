function plot_Flou(plot_para,results)
%画出不同阶数傅里叶描述子还原的轮廓
if results.plot_flag==1
    f_raw=results.im;
    
    %画提取轮廓
%     b=results.b;
%     x_plot_raw=b(:,2);
%     y_plot_raw=b(:,1);
%     imshow(f_raw);
%     hold on
%     plot(x_plot_raw,y_plot_raw,'b.');
%     axis ij
%     axis equal
%     axis on;
%     axis([0 size(f_raw,2) 0 size(f_raw,1)]);%防止抖动
%     hold off;
%     saveas(gcf,[plot_para.save_pic_dir,results.frame_name(1:8),'_Raw_contour.png']);
    
    
    %画还原轮廓
    c=results.c;
    imshow(f_raw);
    hold on;
    n=20;
    for tt=0:1:500
        t=tt/500;
        xt=0;
        for j=1:2*n+1
            nn=j-n-1;
            xt=xt+c(j)*exp(nn*2*pi*1i*t);
        end
        x_plot=real(xt);
        y_plot=imag(xt);
        plot(x_plot,y_plot,'r.');
        axis ij;
        axis equal;
        axis on;
    end
    text(10,10,strcat('n=',num2str(n)));
    hold off;
    saveas(gcf,[plot_para.save_pic_dir,results.frame_name(1:8),'_Flou_contour_20.png']);
    
    
end

end