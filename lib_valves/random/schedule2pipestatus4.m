%% 管道隔离和修复分开。其中泄露管道没有隔离状态。
% 增加管道检查次序
%% 韩朝 2017-12-14 hanzhao@emails.bjut.edu.cn
%% 生成管道状态随时间步变化矩阵。
% 生成状态变化矩阵，当管道状态不变时，管道对应时间步参数为0
%% 输入
% BreakPipe_result BreakPipe_result,(nB,4), 记录：1破坏管道编号\2修复开始时间\3修复结束时间\4维修队伍编号
%% 输出
% PipeStatus,(nB,4), 记录：行为破坏管道，列为时间步；0表示修复完成，1表示关闭，2表示破坏中
% PipeStatusChange(nB,4),
% 记录：行为破坏管道，列为时间步；0表示状态不变，1表示管道状态变为关闭，2表示管道状态变为修复完成
%% example
function [PipeStatus,PipeStatusChange]=schedule2pipestatus4(BreakPipe_result)
if isempty(BreakPipe_result)
    PipeStatus=[];
    PipeStatusChange=[];
    return
end
%%初始化数据
n=numel(BreakPipe_result(:,1));
n_isolation = sum((cell2mat(BreakPipe_result(:,6))==1));
BreakPipe_InspectResult=BreakPipe_result(1:n_isolation,:);
BreakPipe_RepairResult=BreakPipe_result(n_isolation+1:end,:);
nB=numel(BreakPipe_RepairResult(:,1));%破坏管道个数
PipeStatus_original=2*ones(nB,1);%管道初始状态为破坏中
PipeStatusChange_original = zeros(nB,1);
endTime=ceil(max(cell2mat(BreakPipe_RepairResult(:,4))));%最大的修复完成时间为时间步终止
PipeStatus_1=2*ones(nB,endTime);
PipeStatusChange = zeros(nB,endTime);
Pipe_id = sort(cell2mat(BreakPipe_RepairResult(:,1)));
time_1 = zeros(nB,1);%隔离结束时间
time_2 = zeros(nB,1);%修复开始时间
time_3 = zeros(nB,1);%修复结束时间
for i_isolation = 1: n_isolation
    node_id = BreakPipe_InspectResult{i_isolation,1};
    [~,locb] = ismember(node_id,Pipe_id);
    time_1(locb)=ceil(BreakPipe_InspectResult{i_isolation,4});
end
for i_replacement= 1:nB
    node_id = BreakPipe_RepairResult{i_replacement,1};
    [~,locb] = ismember(node_id,Pipe_id);
    time_2(locb)=ceil(BreakPipe_RepairResult{i_replacement,3});
    time_3(locb)=ceil(BreakPipe_RepairResult{i_replacement,4});
end
for i = 1:nB
    if time_1(i)==0
        
    else
        PipeStatus_1(i,time_1(i):time_3(i)-1) = 1;%隔离,修复时管道状态均为隔离
        PipeStatusChange(i,time_1(i)) =1;
    end
    PipeStatus_1(i,time_3(i):end)=0;

    
    PipeStatusChange(i,time_3(i)) =2;
end

PipeStatus=[PipeStatus_original,PipeStatus_1];
PipeStatusChange=[PipeStatusChange_original,PipeStatusChange];
% PipeStatus=PipeStatus_1;
if 0
    keyboard
end
end