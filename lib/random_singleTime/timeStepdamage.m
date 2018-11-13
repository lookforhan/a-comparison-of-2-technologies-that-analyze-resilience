%% 2017-12-15
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 功能：根据管道状态向量改变管道破坏信息
%% 输入
% PipeStatus, 管道状态向量
% damage_pipe_info, 管道破坏信息
%% 输出
% damage_pipe_info_after, 破坏管道的信息
% close_pipe_info, 关闭管道的编号
function [damage_pipe_info_after,close_pipe_info]=timeStepdamage(PipeStatus,damage_pipe_info)
% 初始化参数
M1=damage_pipe_info{1};
M2=damage_pipe_info{2};
M3=damage_pipe_info{3};
M4=damage_pipe_info{4};
M5=damage_pipe_info{5};
M6=damage_pipe_info{6};
M7=damage_pipe_info{7};
%
H1=M1(PipeStatus~=0);%删除管道编号
K1=M1(PipeStatus==2);%破坏管道编号
K2=M2(PipeStatus==2,:);%破坏管道信息
K3=M3(PipeStatus==2,:);%破坏管道信息
K4=M4(PipeStatus==2,:);%破坏管道信息
K5=M5(PipeStatus==2,:);%破坏管道信息
K6=M6(PipeStatus==2,:);%破坏管道信息
K7=M7(PipeStatus==2,:);%破坏管道信息
damage_pipe_info_after=[{K1},{K2},{K3},{K4},{K5},{K6},{K7}];
%：1破坏管线的位置号(向量)；2管线破坏点之前的长度比例(矩阵)；3破坏点的破坏类型(矩阵)；4渗漏破坏点的扩散器系数(矩阵)
close_pipe_info=H1;
end