%% 2017-12-26
%% hanzhao@emails.bjut.edu.cn
%% 根据管道号计算管道中点的坐标
% 输入：
% pipe_num待求的管道号矩阵
% net_data管网信息
% 输出
% coordinate 管道中点的x,y坐标
function coordinate=pipe2coordinate(pipe_loc,net_data)

pipe_num=numel(pipe_loc);%确定需要计算的管道个数
coordinate=cell(pipe_num,3);
pipe_info=net_data{5,2}(pipe_loc,:);%找管道的编号\节点\长度等信息
for i=1:pipe_num
    N1=pipe_info{i,2};%找管道的起始节点编号
    N2=pipe_info{i,3};%找管道的终止节点编号
    N1_loc=ismember(net_data{23,2}(:,1),N1);
    N1_x=net_data{23,2}{N1_loc,2};
    N1_y=net_data{23,2}{N1_loc,3};
    N2_loc=ismember(net_data{23,2}(:,1),N2);
    N2_x=net_data{23,2}{N2_loc,2};
    N2_y=net_data{23,2}{N2_loc,3};
    coordinate{i,1}=pipe_info{i,1};
    coordinate{i,2}=(N1_x+N2_x)/2;
   coordinate{i,3}=(N1_y+N2_y)/2; 
end


end