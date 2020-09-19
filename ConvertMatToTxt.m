%% 读取数据集信息并转化为txt文件
addpath('E:\2020秋\matlab程序\DatasetSelf');
where_is_your_dataset='E:\2020秋\matlab程序\DatasetSelf';
%*c.txt
c_files_struct=dir(fullfile(where_is_your_dataset,'*c.mat'));
c_files= {c_files_struct.name};
for i = 1 : length(c_files)%图片绝对地址
    temp=load([where_is_your_dataset,'\',c_files{i}]);
    temp=temp.c_save;
    temp_real=real(temp);
    temp_imag=imag(temp);
    temp=[temp_real,temp_imag];%组成矩阵写入
    txtname=[where_is_your_dataset,'\',c_files{i}(1:10),'.txt'];
    fid=fopen(txtname,'wt');
    for j=1:size(temp,1)
        for k=1:size(temp,2)
            fprintf(fid,'%g\t',temp(j,k));
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
end

% %*creal.txt
% creal_files_struct=dir(fullfile(where_is_your_dataset,'*creal.mat'));
% creal_files= {creal_files_struct.name};
% for i = 1 : length(creal_files)%图片绝对地址
%     temp=load([where_is_your_dataset,'\',creal_files{i}]);
%     temp=temp.creal_save;
%     txtname=[where_is_your_dataset,'\',creal_files{i}(1:14),'.txt'];
%     fid=fopen(txtname,'wt');
%     fprintf(fid,'%g\n',temp);
%     fclose(fid)
% end
% 
% %*cimag.txt
% cimag_files_struct=dir(fullfile(where_is_your_dataset,'*cimag.mat'));
% cimag_files= {cimag_files_struct.name};
% for i = 1 : length(cimag_files)%图片绝对地址
%     temp=load([where_is_your_dataset,'\',cimag_files{i}]);
%     temp=temp.cimag_save;
%     txtname=[where_is_your_dataset,'\',cimag_files{i}(1:14),'.txt'];
%     fid=fopen(txtname,'wt');
%     fprintf(fid,'%g\n',temp);
%     fclose(fid)
% end
% 
% %*result.txt
% result_files_struct=dir(fullfile(where_is_your_dataset,'*result.mat'));
% result_files= {result_files_struct.name};
% for i = 1 : length(result_files)%图片绝对地址
%     temp=load([where_is_your_dataset,'\',result_files{i}]);
%     temp=temp.res_save;
%     txtname=[where_is_your_dataset,'\',result_files{i}(1:15),'.txt'];
%     fid=fopen(txtname,'wt');
%     fprintf(fid,'%g\n',temp);
%     fclose(fid)
% end