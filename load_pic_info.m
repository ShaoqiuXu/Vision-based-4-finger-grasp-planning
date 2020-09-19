function seq=load_pic_info(database_folder)
img_path=strcat(database_folder,'\');
%��ȡͼƬ��png�ļ���
img_files_struct=dir(fullfile(img_path,'*.png'));
img_files = {img_files_struct.name};
seq.frame_names = img_files;%ͼƬ����
for i = 1 : length(seq.frame_names)%ͼƬ���Ե�ַ
    seq.s_frames{i} = [img_path seq.frame_names{i}];
end

%��ȡgroundtruth��Ϣ(cpos.txt�ļ���
gt_files_struct=dir(fullfile(img_path,'*cpos.txt'));
gt_files= {gt_files_struct.name};
seq.gt_frames = gt_files;%gt����
for i = 1 : length(seq.gt_frames)%gt���Ե�ַ
    seq.gt_frames{i} = [img_path seq.gt_frames{i}];
end

%��ȡgroundtruth���λ����Ϣ
for i = 1 : length(seq.gt_frames)
    file_name=seq.gt_frames{i};
    fid=fopen(file_name);
    tline=fgetl(fid);
    line_num=0;
    position=[0,0];%��λ��
    positioni=[0,0];%ÿ�����ο�λ��
    while ischar(tline)
        line_num=line_num+1;
        %���нǵ��ƽ��λ�ã��൱���������ο��ƽ��λ��
        %�еľ��ο�ΪNaN�������Ҫ������֮��
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
            %ÿ4�����һ���ж�
            if all(isnan(p1))||all(isnan(p2))||all(isnan(p3))||all(isnan(p4))
                positioni=[0,0];
                line_num=line_num-4;%��4�����ϣ����line_num���������ʱ��ҲҪ��4��
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