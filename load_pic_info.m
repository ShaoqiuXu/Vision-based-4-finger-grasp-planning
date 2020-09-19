function seq=load_pic_info(database_folder)
img_path=strcat(database_folder,'\');
%读取图片（png文件）
img_files_struct=dir(fullfile(img_path,'*.png'));
img_files = {img_files_struct.name};
seq.frame_names = img_files;%图片名称
for i = 1 : length(seq.frame_names)%图片绝对地址
    seq.s_frames{i} = [img_path seq.frame_names{i}];
end

%读取groundtruth信息(cpos.txt文件）
gt_files_struct=dir(fullfile(img_path,'*cpos.txt'));
gt_files= {gt_files_struct.name};
seq.gt_frames = gt_files;%gt名称
for i = 1 : length(seq.gt_frames)%gt绝对地址
    seq.gt_frames{i} = [img_path seq.gt_frames{i}];
end

%读取groundtruth里的位置信息
for i = 1 : length(seq.gt_frames)
    file_name=seq.gt_frames{i};
    fid=fopen(file_name);
    tline=fgetl(fid);
    line_num=0;
    position=[0,0];%总位置
    positioni=[0,0];%每个矩形框位置
    while ischar(tline)
        line_num=line_num+1;
        %所有角点的平均位置，相当于三个矩形框的平均位置
        %有的矩形框为NaN，因此需要三个框之和
        if mod(line_num,4)==1
            p1=str2num(tline);
        end
        if mod(line_num,4)==2
            p2=str2num(tline);
        end
        if mod(line_num,4)==3
            p3=str2num(tline);
        end
        if mod(line_num,4)==0
            p4=str2num(tline);
            %每4组进行一次判断
            if all(isnan(p1))||all(isnan(p2))||all(isnan(p3))||all(isnan(p4))
                positioni=[0,0];
                line_num=line_num-4;%这4行作废，因此line_num在下面除的时候也要少4个
            else
                positioni=p1+p2+p3+p4;
                position=position+positioni;               
            end
            positioni=[0,0];
        end
        tline=fgetl(fid);
    end
    fclose(fid);
    seq.gt_center{i}=position/line_num;
end


end