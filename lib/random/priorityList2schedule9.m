%% 2018-11-18，韩朝大修改，增加不同队伍的修复开始时间，修复效率、隔离效率以及移动速度参数
%% 2018-11-13:韩朝，将管道隔离与管道修复工作分开。先将所有断开破坏管道完全隔离，然后逐个修复。本次修改为大修改。
%% 因此，将原来输入参数BreakPipePriority改成两个变量，分别表示隔离次序（isolate_priority）和修复次序（replacement_priority）
%% 2018-1-29:韩朝：由于次序发生变化，修改生成时间表
% 2018-1-29修改恢复模型假设，检查和修复之间无时间间隔。
%% 2017-12-27
%% 韩朝，修改，增加移动时间Dp_travel和检查时间Dp_inspect
%% 2017-12-12
%% 韩朝
%% 功能：由管道修复次序BP生成管道修复开始时间TS、结束时间TE
%% 输入
% BreakPipePriority, (nB,1), 破坏管道元胞数组，记录破坏管道编号，优化后管道次序。
% RepairCrew, (RN,1), 修复队伍元胞数组，记录修复队伍编号
% BreakPipe_order,管道原始次序
%% 输出
% BreakPipe_result,(nB,4), 记录：1破坏管道编号\2修复开始时间\3修复结束时间\4维修队伍编号
% RepairCrew_result,(RN,3),记录：1维修队伍编号\2维修了管道个数\3平均修复时间
%% 应用案例
% [BreakPipe_result,RepairCrew_result]=priorityList2schedule8({'1';'3'},{'2';'3';'1'},{'a';'b'},{'3';'2';'1'},[2;3;5],[6;7;8],[0,2,3;2,0,2;3,2,0],'.\')
function [BreakPipe_result,RepairCrew_result,Active_result]=priorityList2schedule9(isolate_priority,replacement_priority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,out_dir,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel...队伍开始工作时间，修复效率，隔离效率，移动效率
    )
if isempty(isolate_priority)%没有进行修复
    BreakPipe_result = [];
    RepairCrew_result =[];
    return
end
%变量初始化
displacement = 0; %任务类型:移动
isolate = 1;%任务类型：隔离
replacement = 2;%任务类型：替换
% reparation = 3;%任务类型：修复
nB_isolation = numel(isolate_priority);%隔离管道的个数
nB_replacement = numel(replacement_priority);%修复管道个数
displacement_mat = ones(nB_isolation+nB_replacement,1)*displacement;
isolate_mat = ones(nB_isolation ,1)*isolate;
replacement_mat = ones(nB_replacement,1)*replacement;

RN = numel(RepairCrew);%修复队伍个数
TD_I = zeros(nB_isolation,1);%破坏管道**分配**检查任务的时间
TS_I = zeros(nB_isolation,1);%破坏管道**开始**检查任务的时间
TE_I = zeros(nB_isolation,1);%破坏管道**结束**检查任务的时间
TD_R = zeros(nB_replacement,1);%破坏管道**分配**修复时间
TS_R = zeros(nB_replacement,1);%破坏管道**开始**修复时间
TE_R = zeros(nB_replacement,1);%破坏管道**结束**修复时间
Inspect_Record_pipe = cell(nB_isolation,1);%破坏管道被那个队伍检查
Repair_Record_pipe= cell(nB_replacement,1);%破坏管道被那个队伍修复
REneTime = crewStartTime;%维修队伍的修复结束时间（中间变量）
Inspect_Record = zeros(nB_isolation,RN);%记录每个队伍修复哪个管道
Repair_Record = zeros(nB_replacement,RN);%记录每个队伍修复哪个管道
% Record = zeros(nB,RN);%记录每个队伍修复哪个管道
% BreakPipe_result=cell(nB,4);
% RepairCrew_result=cell(RN,3);
BreakPipe_order_mat=cell2mat(BreakPipe_order);
% BreakPipe_Priority_mat=cell2mat(BreakPipePriority);
isolate_priority_mat = cell2mat(isolate_priority);
replacement_priority_mat = cell2mat(replacement_priority);
Record = zeros(nB_isolation+nB_replacement,RN);%记录每个队伍修复哪个管道
% 检查过程
for i = 1:nB_isolation
    
    pipe_n=isolate_priority{i};%第I个管道编号
    [pipe_n2]=find(BreakPipe_order_mat==pipe_n);%管道破坏信息中的管道号;更新pipe_n2
    [TD_I(i),J] = min(REneTime);%分配任务给维修队伍：隔离
    Dp_inspect_i=Dp_Inspect_mat(pipe_n2)*crewEfficiencyIsolation(J);%检查该管道所需的时间
    
    if any(find(Record(1:i,J)~=0))
        Dp_travel_i=Dp_Travel_mat(pipe_n2,pipe_n3);%两个管道之间移动的时间
    else
        Dp_travel_i=0;
    end
    TS_I(i) = TD_I(i)+Dp_travel_i*crewEfficiencyTravel(J);%检查开始时间
    TE_I(i) = TS_I(i)+Dp_inspect_i;%检查结束时间
    REneTime(J) = TE_I(i);%检查（隔离）结束后，队伍可以接收其他任务安排
    Inspect_Record_pipe{i}=RepairCrew{J};
    Inspect_Record(i,J) = Dp_inspect_i;
    %     Record(i,J) = Dp_inspect_i;
    pipe_n3=pipe_n2;%将现有管道号赋予pipe_n3
end
% 修复过程
for i = 1:nB_replacement
    
    pipe_n=replacement_priority{i};%第I个管道编号
    [pipe_n2]=find(BreakPipe_order_mat==pipe_n);%管道破坏信息中的管道号;更新pipe_n2
    [TD_R(i),J] = min(REneTime);%分配任务给维修队伍:修复
    Dp_repair_i=Dp_Repair_mat(pipe_n2)*crewEfficiencyRecovery(J);%修复该管道所需的时间
    
    if any(find(Record(1:i,J)~=0))
        Dp_travel_i=Dp_Travel_mat(pipe_n2,pipe_n3);%两个管道之间移动的时间
    else
        Dp_travel_i=0;
    end
    TS_R(i) = TD_R(i)+Dp_travel_i*crewEfficiencyTravel(J);%分配后，立即开始修复活动
    TE_R(i) = TS_R(i)+Dp_repair_i;%修复结束
    REneTime(J) = TE_R(i);%修复结束后，队伍可以接收其他任务安排
    Repair_Record_pipe{i} = RepairCrew{J};
    Repair_Record(i,J) = Dp_repair_i;
    %     Record(i,J) = Dp_inspect_i;
    pipe_n3=pipe_n2;%将现有管道号赋予pipe_n3
end
% 统统推迟0.25h
T_postpone = 0;
T_postpone_mat_1 = ones(nB_isolation,1)*T_postpone ;
T_postpone_mat_2 = ones(nB_replacement,1)*T_postpone ;
TD_I = TD_I + T_postpone_mat_1;
TS_I = TS_I + T_postpone_mat_1;
TE_I = TE_I + T_postpone_mat_1;
TD_R = TD_R + T_postpone_mat_2;
TS_R = TS_R + T_postpone_mat_2;
TE_R = TE_R + T_postpone_mat_2;
% 分配过程结束，生成输出
[~,locb1]=ismember(BreakPipe_order_mat,isolate_priority_mat);%隔离次序在原管道中
[~,locb2]=ismember(BreakPipe_order_mat,replacement_priority_mat);%修复次序在原管道中
BreakPipe_result11=[num2cell(locb1(locb1~=0)),num2cell(isolate_priority_mat),num2cell(TD_I),num2cell(TS_I),num2cell(TE_I),Inspect_Record_pipe,num2cell(ones(nB_isolation,1))];%检查的记录
BreakPipe_result21=[num2cell(locb2),num2cell(replacement_priority_mat),num2cell(TD_R),num2cell(TS_R),num2cell(TE_R),Repair_Record_pipe,num2cell(ones(nB_replacement,1)*2)];%修复的记录
BreakPipe_result1=sortrows(BreakPipe_result11);%按照BreakPipe_order_mat排序
BreakPipe_result1(:,1)=[];
BreakPipe_result2=sortrows(BreakPipe_result21);%按照BreakPipe_order_mat排序
BreakPipe_result2(:,1)=[];
BreakPipe_result=[BreakPipe_result1;BreakPipe_result2];
if false
    title = {'管道编号','分配时刻（h）','工作（检查/修复）开始时刻（h）','工作（检查/修复）结束时刻','修复队伍'};
    BreakPipe_result5=[title;BreakPipe_result];
    xlswrite([out_dir,'\temp_管道修复结果.xls'],BreakPipe_result5);
end
%--------------------------------------------
theRepairNum_forCrew=sum(Repair_Record~=0,1);%队伍修复管道个数
theMeanDuration=sum(Repair_Record,1)./theRepairNum_forCrew;%平均修复时间
RepairCrew_result=[RepairCrew,num2cell(theRepairNum_forCrew'),num2cell(theMeanDuration')];
if false
    xlswrite([out_dir,'\temp_修复队伍修复结果.xls'],RepairCrew_result);
end
% keyboard
%--------------------------------------------
title2 = {'队伍','分配时刻（h）','工作（检查/修复）开始时刻（h）','管道编号','活动类型：0移动/1隔离/2修复'};
Active_displacement=[[Inspect_Record_pipe,num2cell(TD_I),num2cell(TS_I),num2cell(isolate_priority_mat);Repair_Record_pipe,num2cell(TD_R),num2cell(TS_R),num2cell(replacement_priority_mat)],num2cell(displacement_mat)];
Active_isolation = [Inspect_Record_pipe,num2cell(TS_I),num2cell(TE_I),num2cell(isolate_priority_mat),num2cell(isolate_mat)];
Active_replacement =[Repair_Record_pipe,num2cell(TS_R),num2cell(TE_R),num2cell(replacement_priority_mat),num2cell(replacement_mat)];
Active_result =[title2; [Active_displacement;Active_isolation;Active_replacement]];

xlswrite([out_dir,'\temp_修复队伍修复结果.xls'],Active_result)
% Active_reparation
end
