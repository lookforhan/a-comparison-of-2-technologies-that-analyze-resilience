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
% [BreakPipe_result,RepairCrew_result]=priorityList2schedule4({'1';'2';'3'},{'2';'3';'1'},{'a';'b'},{'3';'2';'1'},[2;3;5],[6;7;8],[0,2,3;2,0,2;3,2,0])
function [BreakPipe_result,RepairCrew_result]=priorityList2schedule5(BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,out_dir)
if isempty(BreakPipePriority)%û�н����޸�
    BreakPipe_result = [];
    RepairCrew_result =[];
    return
end
%������ʼ��
displacement = 0; %��������:�ƶ�
isolate = 1;%�������ͣ�����
replacement = 2;%�������ͣ��滻
reparation = 3;%�������ͣ��޸�
nB = numel(BreakPipe_order);%�ƻ��ܵ��ĸ���
RN = numel(RepairCrew);%�޸��������
TD_I = zeros(nB,1);%�ƻ��ܵ�**����**��������ʱ��
TS_I = zeros(nB,1);%�ƻ��ܵ�**��ʼ**��������ʱ��
TE_I = zeros(nB,1);%�ƻ��ܵ�**����**��������ʱ��
TD_R = zeros(nB,1);%�ƻ��ܵ�**����**�޸�ʱ��
TS_R = zeros(nB,1);%�ƻ��ܵ�**��ʼ**�޸�ʱ��
TE_R = zeros(nB,1);%�ƻ��ܵ�**����**�޸�ʱ��
Inspect_Record_pipe = cell(nB,1);%�ƻ��ܵ����Ǹ�������
Repair_Record_pipe= cell(nB,1);%�ƻ��ܵ����Ǹ������޸�
RET = zeros(1,RN);%ά�޶�����޸�����ʱ�䣨�м������
Inspect_Record = zeros(nB,RN);%��¼ÿ�������޸��ĸ��ܵ�
Repair_Record = zeros(nB,RN);%��¼ÿ�������޸��ĸ��ܵ�
% Record = zeros(nB,RN);%��¼ÿ�������޸��ĸ��ܵ�
% BreakPipe_result=cell(nB,4);
% RepairCrew_result=cell(RN,3);
BreakPipe_order_mat=cell2mat(BreakPipe_order);
BreakPipe_Priority_mat=cell2mat(BreakPipePriority);
Record = zeros(nB,RN);%��¼ÿ�������޸��ĸ��ܵ�
%% �����޸�����
for i = 1:nB
    pipe_n=BreakPipePriority{i};%��I���ܵ����
    [pipe_n2]=find(BreakPipe_order_mat==pipe_n);%�ܵ��ƻ���Ϣ�еĹܵ���;����pipe_n2
    Dp_repair_i=Dp_Repair_mat(pipe_n2);%�޸��ùܵ������ʱ��
    Dp_inspect_i=Dp_Inspect_mat(pipe_n2);%���ùܵ������ʱ��
    [TD_I(i),J] = min(RET);%���������ά�޶���
    if any(find(Record(1:i,J)~=0))
        Dp_travel_i=Dp_Travel_mat(pipe_n2,pipe_n3);%�����ܵ�֮���ƶ���ʱ��
    else        
        Dp_travel_i=0;
    end   
    TS_I(i) = TD_I(i)+Dp_travel_i;%��鿪ʼʱ��
    TE_I(i) = TS_I(i)+Dp_inspect_i;%������ʱ��
    TD_R(i) = TE_I(i);%�������������ʼ�����޸�
    TS_R(i) = TD_R(i);%�����������ʼ�޸��
    TE_R(i) = TS_R(i)+Dp_repair_i;%�޸�����   
    RET(J) = TE_R(i);%�޸������󣬶�����Խ�������������
    Repair_Record_pipe{i} = RepairCrew{J};
    Inspect_Record_pipe{i}=RepairCrew{J};
    Inspect_Record(i,J) = Dp_inspect_i;
    Repair_Record(i,J) = Dp_repair_i;
%     Record(i,J) = Dp_inspect_i;
    pipe_n3=pipe_n2;%�����йܵ��Ÿ���pipe_n3
end
%% ������̽������������
[~,locb1]=ismember(BreakPipe_order_mat,BreakPipe_Priority_mat);%�޸�������ԭ�ܵ���
[~,locb2]=ismember(BreakPipe_order_mat,BreakPipe_Priority_mat);
BreakPipe_result11=[num2cell(locb1),num2cell(BreakPipe_Priority_mat),num2cell(TD_I),num2cell(TS_I),num2cell(TE_I),Inspect_Record_pipe];%���ļ�¼
BreakPipe_result21=[num2cell(locb2),num2cell(BreakPipe_Priority_mat),num2cell(TD_R),num2cell(TS_R),num2cell(TE_R),Repair_Record_pipe];%�޸��ļ�¼
BreakPipe_result1=sortrows(BreakPipe_result11);%����BreakPipe_order_mat����
BreakPipe_result1(:,1)=[];
BreakPipe_result2=sortrows(BreakPipe_result21);%����BreakPipe_order_mat����
BreakPipe_result2(:,1)=[];
BreakPipe_result=[BreakPipe_result1;BreakPipe_result2];
title = {'�ܵ����','����ʱ�̣�h��','���������/�޸�����ʼʱ�̣�h��','���������/�޸�������ʱ��','�޸�����'};
BreakPipe_result5=[title;BreakPipe_result];
xlswrite([out_dir,'\�ܵ��޸����.xls'],BreakPipe_result5);
%--------------------------------------------
theRepairNum_forCrew=sum(Repair_Record~=0,1);%�����޸��ܵ�����
theMeanDuration=sum(Repair_Record,1)./theRepairNum_forCrew;%ƽ���޸�ʱ��
RepairCrew_result=[RepairCrew,num2cell(theRepairNum_forCrew'),num2cell(theMeanDuration')];
xlswrite([out_dir,'\�޸������޸����.xls'],RepairCrew_result);
% keyboard
end