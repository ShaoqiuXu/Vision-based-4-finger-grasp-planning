function Qlrw_Demo_all_seq_0721()
close all;
clc;

%% load all the pictures
where_is_your_pictue='E:\2020Çï\graspdataset\F4';
seq=load_pic_info(where_is_your_pictue);

%% Define saving path
if nargin < 1
    save_dir = '.\resPic\';                              
end

version_name='0722v1';

save_res_dir = [save_dir, version_name, '_res\'];       %the results saving folder
save_pic_dir = [save_res_dir, 'res_picture\'];              %the pictures saving folder

if ~exist(save_res_dir, 'dir')
    mkdir(save_res_dir);
end

if ~exist(save_pic_dir, 'dir')
    mkdir(save_pic_dir);
end

%% Computation
%parameter
plot_para.save_pic_dir=save_pic_dir;
plot_para.save_res_dir=save_res_dir;

%sequence
s_frames=seq.s_frames;
num_frames = numel(s_frames);

time=0;
start_frame=1;%test
% num_frames=20;%test
for frame = start_frame:num_frames
    tic();
    %load image
    im = imread(s_frames{frame});
    im_center=seq.gt_center{frame};
    
    %compute results
    results=ProcessOnePic(im_center,im);
    results.frame=frame;
    results.frame_name=seq.frame_names{frame};
    
    %plot and save results
    plot_Res(plot_para,results);
end
time=time+toc()
end