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
function [PipeStatus,PipeStatusChange]=schedule2pipestatus3(BreakPipe_result)
if isempty(BreakPipe_result)
    PipeStatus=[];
    PipeStatusChange=[];
    return
end
%%��ʼ������
n=numel(BreakPipe_result(:,1));
BreakPipe_InspectResult=BreakPipe_result(1:n/2,:);
BreakPipe_RepairResult=BreakPipe_result(n/2+1:end,:);
nB=numel(BreakPipe_RepairResult(:,1));%�ƻ��ܵ�����
PipeStatus_original=2*ones(nB,1);%�ܵ���ʼ״̬Ϊ�ƻ���
endTime=ceil(max(cell2mat(BreakPipe_RepairResult(:,4))));%�����޸����ʱ��Ϊʱ�䲽��ֹ
PipeStatus_1=2*ones(nB,endTime);
PipeStatusChange = zeros(nB,endTime);

for i=1:nB
    time_1=ceil(BreakPipe_InspectResult{i,4});
    time_2=ceil(BreakPipe_RepairResult{i,4});
    if time_1==0
        PipeStatus_1(i,1:time_2)=1;
        
    else
        if time_2~=time_1
            PipeStatus_1(i,time_1:time_2)=1;
            
        end
    end
    PipeStatus_1(i,time_2:end)=0;
    PipeStatusChange(i,time_1) =1;
    PipeStatusChange(i,time_2) =2;
end
% PipeStatus=[PipeStatus_original,PipeStatus_1];
PipeStatus=PipeStatus_1;
if 0
    keyboard
end
end