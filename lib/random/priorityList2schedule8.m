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
% [BreakPipe_result,RepairCrew_result]=priorityList2schedule8({'1';'3'},{'2';'3';'1'},{'a';'b'},{'3';'2';'1'},[2;3;5],[6;7;8],[0,2,3;2,0,2;3,2,0],'.\')
function [BreakPipe_result,RepairCrew_result,Active_result]=priorityList2schedule8(isolate_priority,replacement_priority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,out_dir)
if isempty(isolate_priority)%û�н����޸�
    BreakPipe_result = [];
    RepairCrew_result =[];
    return
end
%������ʼ��
displacement = 0; %��������:�ƶ�
isolate = 1;%�������ͣ�����
replacement = 2;%�������ͣ��滻
% reparation = 3;%�������ͣ��޸�
nB_isolation = numel(isolate_priority);%����ܵ��ĸ���
nB_replacement = numel(replacement_priority);%�޸��ܵ�����
displacement_mat = ones(nB_isolation+nB_replacement,1)*displacement;
isolate_mat = ones(nB_isolation ,1)*isolate;
replacement_mat = ones(nB_replacement,1)*replacement;

RN = numel(RepairCrew);%�޸��������
TD_I = zeros(nB_isolation,1);%�ƻ��ܵ�**����**��������ʱ��
TS_I = zeros(nB_isolation,1);%�ƻ��ܵ�**��ʼ**��������ʱ��
TE_I = zeros(nB_isolation,1);%�ƻ��ܵ�**����**��������ʱ��
TD_R = zeros(nB_replacement,1);%�ƻ��ܵ�**����**�޸�ʱ��
TS_R = zeros(nB_replacement,1);%�ƻ��ܵ�**��ʼ**�޸�ʱ��
TE_R = zeros(nB_replacement,1);%�ƻ��ܵ�**����**�޸�ʱ��
Inspect_Record_pipe = cell(nB_isolation,1);%�ƻ��ܵ����Ǹ�������
Repair_Record_pipe= cell(nB_replacement,1);%�ƻ��ܵ����Ǹ������޸�
RET = zeros(1,RN);%ά�޶�����޸�����ʱ�䣨�м������
Inspect_Record = zeros(nB_isolation,RN);%��¼ÿ�������޸��ĸ��ܵ�
Repair_Record = zeros(nB_replacement,RN);%��¼ÿ�������޸��ĸ��ܵ�
% Record = zeros(nB,RN);%��¼ÿ�������޸��ĸ��ܵ�
% BreakPipe_result=cell(nB,4);
% RepairCrew_result=cell(RN,3);
BreakPipe_order_mat=cell2mat(BreakPipe_order);
% BreakPipe_Priority_mat=cell2mat(BreakPipePriority);
isolate_priority_mat = cell2mat(isolate_priority);
replacement_priority_mat = cell2mat(replacement_priority);
Record = zeros(nB_isolation+nB_replacement,RN);%��¼ÿ�������޸��ĸ��ܵ�
% ������
for i = 1:nB_isolation
    
    pipe_n=isolate_priority{i};%��I���ܵ����
    [pipe_n2]=find(BreakPipe_order_mat==pipe_n);%�ܵ��ƻ���Ϣ�еĹܵ���;����pipe_n2
    Dp_inspect_i=Dp_Inspect_mat(pipe_n2);%���ùܵ������ʱ��
    [TD_I(i),J] = min(RET);%���������ά�޶��飺����
    if any(find(Record(1:i,J)~=0))
        Dp_travel_i=Dp_Travel_mat(pipe_n2,pipe_n3);%�����ܵ�֮���ƶ���ʱ��
    else
        Dp_travel_i=0;
    end
    TS_I(i) = TD_I(i)+Dp_travel_i;%��鿪ʼʱ��
    TE_I(i) = TS_I(i)+Dp_inspect_i;%������ʱ��
    RET(J) = TE_I(i);%��飨���룩�����󣬶�����Խ�������������
    Inspect_Record_pipe{i}=RepairCrew{J};
    Inspect_Record(i,J) = Dp_inspect_i;
    %     Record(i,J) = Dp_inspect_i;
    pipe_n3=pipe_n2;%�����йܵ��Ÿ���pipe_n3
end
% �޸�����
for i = 1:nB_replacement
    
    pipe_n=replacement_priority{i};%��I���ܵ����
    [pipe_n2]=find(BreakPipe_order_mat==pipe_n);%�ܵ��ƻ���Ϣ�еĹܵ���;����pipe_n2
    Dp_repair_i=Dp_Repair_mat(pipe_n2);%�޸��ùܵ������ʱ��
    [TD_R(i),J] = min(RET);%���������ά�޶���:�޸�
    if any(find(Record(1:i,J)~=0))
        Dp_travel_i=Dp_Travel_mat(pipe_n2,pipe_n3);%�����ܵ�֮���ƶ���ʱ��
    else
        Dp_travel_i=0;
    end
    TS_R(i) = TD_R(i);%�����������ʼ�޸��
    TE_R(i) = TS_R(i)+Dp_repair_i;%�޸�����
    RET(J) = TE_R(i);%�޸������󣬶�����Խ�������������
    Repair_Record_pipe{i} = RepairCrew{J};
    Repair_Record(i,J) = Dp_repair_i;
    %     Record(i,J) = Dp_inspect_i;
    pipe_n3=pipe_n2;%�����йܵ��Ÿ���pipe_n3
end
% ͳͳ�Ƴ�0.25h
T_postpone = 0.25;
T_postpone_mat_1 = ones(nB_isolation,1)*T_postpone ;
T_postpone_mat_2 = ones(nB_replacement,1)*T_postpone ;
TD_I = TD_I + T_postpone_mat_1;
TS_I = TS_I + T_postpone_mat_1;
TE_I = TE_I + T_postpone_mat_1;
TD_R = TD_R + T_postpone_mat_2;
TS_R = TS_R + T_postpone_mat_2;
TE_R = TE_R + T_postpone_mat_2;
% ������̽������������
[~,locb1]=ismember(BreakPipe_order_mat,isolate_priority_mat);%���������ԭ�ܵ���
[~,locb2]=ismember(BreakPipe_order_mat,replacement_priority_mat);%�޸�������ԭ�ܵ���
BreakPipe_result11=[num2cell(locb1(locb1~=0)),num2cell(isolate_priority_mat),num2cell(TD_I),num2cell(TS_I),num2cell(TE_I),Inspect_Record_pipe,num2cell(ones(nB_isolation,1))];%���ļ�¼
BreakPipe_result21=[num2cell(locb2),num2cell(replacement_priority_mat),num2cell(TD_R),num2cell(TS_R),num2cell(TE_R),Repair_Record_pipe,num2cell(ones(nB_replacement,1)*2)];%�޸��ļ�¼
BreakPipe_result1=sortrows(BreakPipe_result11);%����BreakPipe_order_mat����
BreakPipe_result1(:,1)=[];
BreakPipe_result2=sortrows(BreakPipe_result21);%����BreakPipe_order_mat����
BreakPipe_result2(:,1)=[];
BreakPipe_result=[BreakPipe_result1;BreakPipe_result2];
if false
    title = {'�ܵ����','����ʱ�̣�h��','���������/�޸�����ʼʱ�̣�h��','���������/�޸�������ʱ��','�޸�����'};
    BreakPipe_result5=[title;BreakPipe_result];
    xlswrite([out_dir,'\temp_�ܵ��޸����.xls'],BreakPipe_result5);
end
%--------------------------------------------
theRepairNum_forCrew=sum(Repair_Record~=0,1);%�����޸��ܵ�����
theMeanDuration=sum(Repair_Record,1)./theRepairNum_forCrew;%ƽ���޸�ʱ��
RepairCrew_result=[RepairCrew,num2cell(theRepairNum_forCrew'),num2cell(theMeanDuration')];
if false
    xlswrite([out_dir,'\temp_�޸������޸����.xls'],RepairCrew_result);
end
% keyboard
%--------------------------------------------
title2 = {'����','����ʱ�̣�h��','���������/�޸�����ʼʱ�̣�h��','�ܵ����','����ͣ�0�ƶ�/1����/2�޸�'};
Active_displacement=[[Inspect_Record_pipe,num2cell(TD_I),num2cell(TS_I),num2cell(isolate_priority_mat);Repair_Record_pipe,num2cell(TD_R),num2cell(TS_R),num2cell(replacement_priority_mat)],num2cell(displacement_mat)];
Active_isolation = [Inspect_Record_pipe,num2cell(TS_I),num2cell(TE_I),num2cell(isolate_priority_mat),num2cell(isolate_mat)];
Active_replacement =[Repair_Record_pipe,num2cell(TS_R),num2cell(TE_R),num2cell(replacement_priority_mat),num2cell(replacement_mat)];
Active_result =[title2; [Active_displacement;Active_isolation;Active_replacement]];

xlswrite([out_dir,'\temp_�޸������޸����.xls'],Active_result)
% Active_reparation
end
