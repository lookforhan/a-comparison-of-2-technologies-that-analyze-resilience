%% 2018-11-18���������޸ģ����Ӳ�ͬ������޸���ʼʱ�䣬�޸�Ч�ʡ�����Ч���Լ��ƶ��ٶȲ���
%% 2018-11-13:���������ܵ�������ܵ��޸������ֿ����Ƚ����жϿ��ƻ��ܵ���ȫ���룬Ȼ������޸��������޸�Ϊ���޸ġ�
%% ��ˣ���ԭ���������BreakPipePriority�ĳ������������ֱ��ʾ�������isolate_priority�����޸�����replacement_priority��
%% 2018-1-29:���������ڴ������仯���޸�����ʱ���
% 2018-1-29�޸Ļָ�ģ�ͼ��裬�����޸�֮����ʱ������
%% 2017-12-27
%% �������޸ģ������ƶ�ʱ��Dp_travel�ͼ��ʱ��Dp_inspect
%% 2017-12-12
%% ����
%% ���ܣ��ɹܵ��޸�����BP���ɹܵ��޸���ʼʱ��TS������ʱ��TE
%% ����
% BreakPipePriority, (nB,1), �ƻ��ܵ�Ԫ�����飬��¼�ƻ��ܵ���ţ��Ż���ܵ�����
% RepairCrew, (RN,1), �޸�����Ԫ�����飬��¼�޸�������
% BreakPipe_order,�ܵ�ԭʼ����
%% ���
% BreakPipe_result,(nB,4), ��¼��1�ƻ��ܵ����\2�޸���ʼʱ��\3�޸�����ʱ��\4ά�޶�����
% RepairCrew_result,(RN,3),��¼��1ά�޶�����\2ά���˹ܵ�����\3ƽ���޸�ʱ��
%% Ӧ�ð���
% [BreakPipe_result,RepairCrew_result,Active_result]=priorityList2schedule10_2_step_one({'1';'3'},{'a';'b'},{'3';'2';'1'},[2;3;5],[6;7;8],[0,2,3;2,0,2;3,2,0],'.\',[1;1],[1;1],[1;1],[1;1])
function [BreakPipe_result,RepairCrew_result,Active_result]=priorityList2schedule10_2_step_one(isolate_priority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,out_dir,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel...���鿪ʼ����ʱ�䣬�޸�Ч�ʣ�����Ч�ʣ��ƶ�Ч��
    )
if isempty(isolate_priority)%û�н����޸�
    BreakPipe_result = [];
    RepairCrew_result =[];
    return
end
%������ʼ��
displacement = 0; %��������:�ƶ�
isolate = 1;%�������ͣ�����
nB_isolation = numel(isolate_priority);%����ܵ��ĸ���
displacement_mat = ones(nB_isolation,1)*displacement;
isolate_mat = ones(nB_isolation ,1)*isolate;

RN = numel(RepairCrew);%�޸��������
TD_I = zeros(nB_isolation,1);%�ƻ��ܵ�**����**��������ʱ��
TS_I = zeros(nB_isolation,1);%�ƻ��ܵ�**��ʼ**��������ʱ��
TE_I = zeros(nB_isolation,1);%�ƻ��ܵ�**����**��������ʱ��

Inspect_Record_pipe = cell(nB_isolation,1);%�ƻ��ܵ����Ǹ�������

REndTime = crewStartTime;%ά�޶�����޸�����ʱ�䣨�м������
Inspect_Record = zeros(nB_isolation,RN);%��¼ÿ����������ĸ��ܵ�
BreakPipe_order_mat=cell2mat(BreakPipe_order);
isolate_priority_mat = cell2mat(isolate_priority);
Record = zeros(nB_isolation,RN);%��¼ÿ�������޸��ĸ��ܵ�
% ������
for i = 1:nB_isolation
    
    pipe_n=isolate_priority_mat(i);%��I���ܵ����
    [pipe_n2]=find(BreakPipe_order_mat==pipe_n);%�ܵ��ƻ���Ϣ�еĹܵ���;����pipe_n2
    [TD_I(i),J] = min(REndTime);%���������ά�޶��飺����
    Dp_inspect_i=Dp_Inspect_mat(pipe_n2)*crewEfficiencyIsolation(J);%���ùܵ������ʱ��
    
    if any(find(Record(1:i,J)~=0))
        Dp_travel_i=Dp_Travel_mat(pipe_n2,pipe_n3);%�����ܵ�֮���ƶ���ʱ��
    else
        Dp_travel_i=0;
    end
    TS_I(i) = TD_I(i)+Dp_travel_i*crewEfficiencyTravel(J);%��鿪ʼʱ��
    TE_I(i) = TS_I(i)+Dp_inspect_i;%������ʱ��
    REndTime(J) = TE_I(i);%��飨���룩�����󣬶�����Խ�������������
    Inspect_Record_pipe{i}=RepairCrew{J};
    Inspect_Record(i,J) = Dp_inspect_i;
    pipe_n3=pipe_n2;%�����йܵ��Ÿ���pipe_n3
end

% ������̽������������
[~,locb1]=ismember(BreakPipe_order_mat,isolate_priority_mat);%���������ԭ�ܵ���
BreakPipe_result11=[num2cell(locb1(locb1~=0)),num2cell(isolate_priority_mat),num2cell(TD_I),num2cell(TS_I),num2cell(TE_I),Inspect_Record_pipe,num2cell(ones(nB_isolation,1))];%���ļ�¼
BreakPipe_result1=sortrows(BreakPipe_result11);%����BreakPipe_order_mat����
BreakPipe_result1(:,1)=[];
BreakPipe_result = BreakPipe_result1;

Record = Inspect_Record;
theRepairNum_forCrew=sum(Record ~=0,1);%�����޸��ܵ�����
theMeanDuration=sum(Record,1)./theRepairNum_forCrew;%ƽ���޸�ʱ��
RepairCrew_result=[RepairCrew,num2cell(theRepairNum_forCrew'),num2cell(theMeanDuration'),num2cell(crewStartTime),num2cell(REndTime)];

% keyboard
%--------------------------------------------
title2 = {'����','����ʱ�̣�h��','���������/�޸�����ʼʱ�̣�h��','���������/�޸�������ʱ�̣�h��','�ܵ����','����ͣ�0�ƶ�/1����/2�޸�'};
Active_displacement=[[Inspect_Record_pipe,num2cell(TD_I),num2cell(TD_I),num2cell(TS_I),num2cell(isolate_priority_mat)],num2cell(displacement_mat)];
Active_isolation = [Inspect_Record_pipe,num2cell(TD_I),num2cell(TS_I),num2cell(TE_I),num2cell(isolate_priority_mat),num2cell(isolate_mat)];
Active_result =[title2; [Active_displacement;Active_isolation]];
% xlswrite([out_dir,'\temp_�޸������޸����.xls'],Active_result)
% Active_reparation
end
