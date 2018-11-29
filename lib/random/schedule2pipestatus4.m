%% �ܵ�������޸��ֿ�������й¶�ܵ�û�и���״̬��
% ���ӹܵ�������
%% ���� 2017-12-14 hanzhao@emails.bjut.edu.cn
%% ���ɹܵ�״̬��ʱ�䲽�仯����
% ����״̬�仯���󣬵��ܵ�״̬����ʱ���ܵ���Ӧʱ�䲽����Ϊ0
%% ����
% BreakPipe_result BreakPipe_result,(nB,4), ��¼��1�ƻ��ܵ����\2�޸���ʼʱ��\3�޸�����ʱ��\4ά�޶�����
%% ���
% PipeStatus,(nB,4), ��¼����Ϊ�ƻ��ܵ�����Ϊʱ�䲽��0��ʾ�޸���ɣ�1��ʾ�رգ�2��ʾ�ƻ���
% PipeStatusChange(nB,4),
% ��¼����Ϊ�ƻ��ܵ�����Ϊʱ�䲽��0��ʾ״̬���䣬1��ʾ�ܵ�״̬��Ϊ�رգ�2��ʾ�ܵ�״̬��Ϊ�޸����
%% example
function [PipeStatus,PipeStatusChange]=schedule2pipestatus4(BreakPipe_result)
if isempty(BreakPipe_result)
    PipeStatus=[];
    PipeStatusChange=[];
    return
end
%%��ʼ������
n=numel(BreakPipe_result(:,1));
n_isolation = sum((cell2mat(BreakPipe_result(:,6))==1));
BreakPipe_InspectResult=BreakPipe_result(1:n_isolation,:);
BreakPipe_RepairResult=BreakPipe_result(n_isolation+1:end,:);
nB=numel(BreakPipe_RepairResult(:,1));%�ƻ��ܵ�����
PipeStatus_original=2*ones(nB,1);%�ܵ���ʼ״̬Ϊ�ƻ���
PipeStatusChange_original = zeros(nB,1);
endTime=ceil(max(cell2mat(BreakPipe_RepairResult(:,4))));%�����޸����ʱ��Ϊʱ�䲽��ֹ
PipeStatus_1=2*ones(nB,endTime);
PipeStatusChange = zeros(nB,endTime);
Pipe_id = sort(cell2mat(BreakPipe_RepairResult(:,1)));
time_1 = zeros(nB,1);%�������ʱ��
time_2 = zeros(nB,1);%�޸���ʼʱ��
time_3 = zeros(nB,1);%�޸�����ʱ��
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
        PipeStatus_1(i,time_1(i):time_3(i)-1) = 1;%����,�޸�ʱ�ܵ�״̬��Ϊ����
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