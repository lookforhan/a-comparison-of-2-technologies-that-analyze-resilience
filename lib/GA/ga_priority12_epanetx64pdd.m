% �½�һ����������¼ģ����ĸ��壬���Ƚ�
% ������epanetx64pdd.dllʱ����д���Ŵ������̡���ga_priority6.m�Ļ������޸ġ�
function [results]...
    =ga_priority12_epanetx64pdd(popsize,generation_Nmax,pc,pm,...��Ⱥ��С������������������ʣ��������
    out_dir,....���Ŀ¼
    RepairCrew,...�޸����飬
    damage_pipe_info,net_data,pipe_relative,...�ƻ���Ϣ��������Ϣ���ƻ��ܵ�����½��ܵ�
    EPA_format,...node_original_data,system_original_L,...EPA��ʽ���ڵ�ԭ�����ݣ�ϵͳԭ���ܵ�����
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...���ʱ�䣬�޸�ʱ�䣬�ƶ�ʱ��
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
    output_net_filename_inp)%,...
results=struct('errcode',0,'isolation_fit_record',[],'isolation_pop_record',[],'best_indivi_isolation',[],...
    'recovery_fit_record',[],'recovery_pop_record',[],'best_indivi_recovery',[]);%��������ýṹ����
% process_1 the optimization of isolation priority
BreakPipe_order = damage_pipe_info{1}(damage_pipe_info{3}==2);%��Ҫ����Ĺܵ�
[pop_isolation_init]=initpop4(popsize,BreakPipe_order);
pop_isolation_record = pop_isolation_init;%��¼����
Fit_isolation_max = zeros(generation_Nmax,1);
Fit_isolation_mean = zeros(generation_Nmax,1);
pop_isolation_uniq = pop_isolation_init;
Fit_record = zeros(popsize*generation_Nmax,1);
ENrun_number_init_isolation = zeros(popsize,generation_Nmax);
for generation_i = 1:generation_Nmax
    generation_dir_i=[out_dir,'process_1\','�Ŵ���',num2str(generation_i),'��\'];
    mkdir(generation_dir_i);
    timeCost = toc;
    disp(['===========process 1:�Ŵ���',num2str(generation_i),'������ʱ',num2str(timeCost),'S========']);
    if ~isempty(pop_isolation_uniq)
        [Fit_isolation_uniq,~,ENrun_number_isolation]=calfitvalue4_isolation(pop_isolation_uniq,damage_pipe_info{1},RepairCrew,...
            Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
            crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
            damage_pipe_info,net_data,...
            EPA_format,...
            generation_dir_i,...
            output_net_filename_inp,pipe_relative);%,...
    else
        Fit_isolation_uniq = [];
        ENrun_number_isolation =[];
%         if obj.dispKeyWord ==1
%             disp('haha:�ظ�����')
%         end
    end
    
    if generation_i==1
        Fit_init = Fit_isolation_uniq;
        Fit_record((generation_i-1)*popsize+1:(generation_i-1)*popsize+popsize)= Fit_init;
        pop_isolation_old = pop_isolation_init;
        ENrun_number_init_isolation(:,generation_i) = ENrun_number_isolation;
    else
%         keyboard
        Fit_init(:) = 0;
        try
            for i_new_indivi = 1:num_new_indivi
                Fit_init(logical(locb_new_indivi(:,i_new_indivi))) = Fit_isolation_uniq(i_new_indivi);%�������������Ӧ��ֵ��ֵ����Ӧ�����Ӧ��λ�á�
                ENrun_number_init_isolation(find(locb_new_indivi(:,i_new_indivi)==1,1),generation_i) = ENrun_number_isolation(i_new_indivi);%����������е�ˮ��ƽ�������ֵ����Ӧ���壬��ͬ����ֻ��ֵ����һ����
            end
        catch
            disp('hehe')
            keyboard
        end
        for i_not_new_indivi = 1:num_not_new_indivi
            Fit_init(logical(locb_not_new_indivi(:,i_not_new_indivi))) =Fit_record(locb_not_new_indivi_fit(i_not_new_indivi));
        end
        Fit_record((generation_i-1)*popsize+1:(generation_i-1)*popsize+popsize) = Fit_init;
        pop_isolation_old = newPop_isolation;
        % pop_uniq(lia1,:)
    end
%     keyboard
    Fit_isolation_max(generation_i,1) = max(Fit_init);
    Fit_isolation_mean(generation_i,1) = mean(Fit_init);
    [ newPop_isolation ] = ga_process( pop_isolation_old,Fit_init,pm,pc );
    [ pop_new,pop_new_not,new_individual_record_mat ] = ga_unique_individual3( newPop_isolation,pop_isolation_record );
%     [~,locb1] = ismember(pop_uniq,newPop_isolation,'rows');
%     [~,locb1_1] = ismember(newPop_isolation,pop_uniq,'rows');
%     [~,locb2] = ismember(pop_uniq_not,newPop_isolation,'rows');
%      [~,locb2_1] = ismember(newPop_isolation,pop_uniq_not,'rows');
%     [~,locb3] = ismember(pop_uniq_not,pop_isolation_record,'rows');
%      [~,locb3_1] = ismember(pop_isolation_record,pop_uniq_not,'rows');
[pop_new_uniq,~,~] = unique(pop_new,'rows','stable');% ��û�н��й�ˮ�������ĸ�����м�飬�޳��ظ����塣
[pop_new_not_uniq,~,~] = unique(pop_new_not,'rows','stable');% 
    pop_isolation_uniq = pop_new_uniq;
    pop_isolation_record=new_individual_record_mat;
    num_new_indivi = numel(pop_new_uniq(:,1));
    locb_new_indivi = zeros(numel(newPop_isolation(:,1)),num_new_indivi);
    for i_new_indivi = 1:num_new_indivi
        [locb_new_indivi(:,i_new_indivi) ] = ismember(newPop_isolation,pop_new_uniq(i_new_indivi,:) ,'rows');
    end
    num_not_new_indivi = numel(pop_new_not_uniq(:,1));
    locb_not_new_indivi = zeros(numel(newPop_isolation(:,1)),num_not_new_indivi);
    locb_not_new_indivi_fit = zeros(1,num_not_new_indivi);
    for i_not_new_indivi = 1:num_not_new_indivi
        [locb_not_new_indivi(:,i_not_new_indivi) ] = ismember(newPop_isolation,pop_new_not_uniq(i_not_new_indivi,:) ,'rows');
        [~,locb_not_new_indivi_fit(i_not_new_indivi)] = ismember(pop_new_not_uniq(i_not_new_indivi,:) ,pop_isolation_record(1:end-popsize,:),'rows');
    end
end

[~,a2] = max(Fit_record); 
best_indivi_isolation = pop_isolation_record(a2,:);
results.isolation_fit_record = Fit_record;
results.isolation_pop_record = pop_isolation_record(1:end-popsize,:);
results.best_indivi_isolation = best_indivi_isolation;
results.isolation_ENrun_num = ENrun_number_init_isolation;
global n_ENrun
test = n_ENrun - sum(sum(ENrun_number_init_isolation));
if test ~=0
    keyboard
end
% process_2 the optimization of recovery reiority
DamagePipe_order = damage_pipe_info{1};%��Ҫ�޸��Ĺܵ�
[pop_recovery_init]=initpop4(popsize,DamagePipe_order);
pop_recovery_record = pop_recovery_init;%��¼����
Fit_recovery_max = zeros(generation_Nmax,1);
Fit_recovery_mean = zeros(generation_Nmax,1);
pop_recovery_uniq = pop_recovery_init;
Fit_recovery_record = zeros(popsize*generation_Nmax,1);
ENrun_number_init_recovery = zeros(popsize,generation_Nmax);
% keyboard
for generation_i = 1:generation_Nmax
    generation_dir_i=[out_dir,'process_2\','�Ŵ���',num2str(generation_i),'��\'];
    mkdir(generation_dir_i);
    timeCost = toc;
    disp(['===========process 2:�Ŵ���',num2str(generation_i),'������ʱ',num2str(timeCost),'S========']);
    if ~isempty(pop_recovery_uniq)
        [Fit_recovery_uniq,~,ENrun_number_recovery]=calfitvalue4_recovery(best_indivi_isolation,pop_recovery_uniq,DamagePipe_order,RepairCrew,...
     Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
     crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
    damage_pipe_info,net_data,...
    EPA_format,...
    generation_dir_i,...
output_net_filename_inp,pipe_relative);%,....
    else
%         if obj.dispKeyWord ==1
%             disp('haha')
%         end
        Fit_recovery_uniq = [];
        ENrun_number_recovery=[];
        
    end
    if generation_i==1
        Fit_init = Fit_recovery_uniq;
        Fit_recovery_record((generation_i-1)*popsize+1:(generation_i-1)*popsize+popsize) = Fit_init;
        pop_recovery_old = pop_recovery_init;
        ENrun_number_init_recovery(:,generation_i) = ENrun_number_recovery;
    else
        Fit_init(:)=0;
        for i_new_indivi = 1:num_new_indivi
           Fit_init(logical(locb_recovery_new_indivi(:,i_new_indivi))) = Fit_recovery_uniq(i_new_indivi); 
           ENrun_number_init_recovery(find(locb_recovery_new_indivi(:,i_new_indivi)==1,1),generation_i) = ENrun_number_recovery(i_new_indivi);
        end
        for i_not_new_indivi = 1:num_not_new_indivi
            Fit_init(logical(locb_recovery_not_new_indivi(:,i_not_new_indivi))) = Fit_recovery_record(locb_recovery_not_new_indivi_fit(i_not_new_indivi));
        end
%         Fit_init(locb1_re) = Fit_recovery_uniq;
%         Fit_init(locb2_re) = Fit_recovery_record(locb3_re);
        Fit_recovery_record((generation_i-1)*popsize+1:(generation_i-1)*popsize+popsize) = Fit_init;
        pop_recovery_old = newPop_recovery;

        % pop_uniq(lia1,:)
    end
    Fit_recovery_max(generation_i,1) = max(Fit_init);
    Fit_recovery_mean(generation_i,1) = mean(Fit_init);
    [ newPop_recovery ] = ga_process( pop_recovery_old,Fit_init,pm,pc );
    [ pop_new_recovery,pop_new_not_recovery,new_individual_record_mat_recovery ] = ga_unique_individual3( newPop_recovery,pop_recovery_record );
%     [~,locb1_re] = ismember(pop_uniq_recovery,newPop_recovery,'rows');
%     [~,locb2_re] = ismember(pop_uniq_not_recovery,newPop_recovery,'rows');
%     [~,locb3_re] = ismember(pop_uniq_not_recovery,pop_recovery_record,'rows');
[pop_recovery_new_uniq,~,~] = unique(pop_new_recovery,'rows','stable');% ��û�н��й�ˮ�������ĸ�����м�飬�޳��ظ����塣
[pop_recovery_new_not_uniq,~,~] = unique(pop_new_not_recovery,'rows','stable');% 
    pop_recovery_uniq = pop_recovery_new_uniq;
    pop_recovery_record=new_individual_record_mat_recovery;
     num_new_indivi = numel(pop_recovery_new_uniq(:,1));
    locb_recovery_new_indivi = zeros(numel(newPop_recovery(:,1)),num_new_indivi);
    for i_new_indivi = 1:num_new_indivi
        [locb_recovery_new_indivi(:,i_new_indivi) ] = ismember(newPop_recovery,pop_recovery_new_uniq(i_new_indivi,:) ,'rows');
    end
    num_not_new_indivi = numel(pop_recovery_new_not_uniq(:,1));
    locb_recovery_not_new_indivi = zeros(numel(newPop_recovery(:,1)),num_not_new_indivi);
    locb_recovery_not_new_indivi_fit = zeros(1,num_not_new_indivi);
    for i_not_new_indivi = 1:num_not_new_indivi
        [locb_recovery_not_new_indivi(:,i_not_new_indivi) ] = ismember(newPop_recovery,pop_recovery_new_not_uniq(i_not_new_indivi,:) ,'rows');
        [~,locb_recovery_not_new_indivi_fit(i_not_new_indivi)] = ismember(pop_recovery_new_not_uniq(i_not_new_indivi,:) ,pop_recovery_record(1:end-popsize,:),'rows');
    end
end
[~,b2] = max(Fit_recovery_record); 
best_indivi_recovery = pop_recovery_record(b2,:);
results.recovery_fit_record = Fit_recovery_record;
results.recovery_pop_record = pop_recovery_record(1:end-popsize,:);
results.best_indivi_recovery = best_indivi_recovery;
results.recovery_ENrun_num = ENrun_number_init_recovery;
test2 = n_ENrun - (sum(sum(ENrun_number_init_recovery))+sum(sum(ENrun_number_init_isolation)));
if test2~=test
    keyboard
end
end
function [Fit,fitvalue,ENrun_number]=calfitvalue4_isolation(pop,BreakPipe_order,RepairCrew,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
    ~,net_data,...
    ~,...
    generation_dir_i,...
    output_net_filename_inp,pipe_relative)%,...
popsize = numel(pop(:,1));
Fitness= zeros(popsize,1);
fitvalue=cell(popsize,15);
ENrun_number = zeros(popsize,1);
for individual_i=1:popsize
    individual_dir_i=[generation_dir_i,'\',num2str(individual_i),'\'];
    mkdir(individual_dir_i)
    BreakPipePriority=pop(individual_i,:);
    
    %fit5
    [Fitness(individual_i),...
        ~,...
        ~,...
        ~,...
        ~,...
        results_isolation]...
        =fit7_isolation...
        (BreakPipePriority,...
        BreakPipe_order,RepairCrew,...
        Dp_Inspect_mat,...
        Dp_Repair_mat,Dp_Travel_mat,...
        net_data,...
        individual_dir_i,...
        output_net_filename_inp,...
        pipe_relative,...
        crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%������Ⱥ������Ӧ��
    ENrun_number(individual_i) = results_isolation.ENrun_num;
end
Fit = Fitness;
end
function [Fitness,...
    BreakPipe_result,...
    RepairCrew_result,...
    system_serviceability_cell,...
    activity_cell,results]...
    =fit7_isolation...
    (BreakPipePriority,...
    BreakPipe_order,RepairCrew,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...
    net_data,...
    output_result_dir,...
    output_net_filename_inp,...
    pipe_relative,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel)%������Ⱥ������Ӧ��
% funcName = 'fit7_isolation';
BreakPipePriority_cell = num2cell(BreakPipePriority');
DamagePipePriority_cell = num2cell(BreakPipe_order);
[BreakPipe_result,RepairCrew_result]=priorityList2schedule10_2_step_one(BreakPipePriority_cell,RepairCrew,DamagePipePriority_cell,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%�����޸���������ʱ����������޸��ֿ��Ĳ��� from 'random\'
[PipeStatus2,PipeStatusChange]=schedule2pipestatus5_isolation(BreakPipe_result,BreakPipe_order);%����ʱ������ɹܵ�״̬����
if isempty(PipeStatus2)
    PipeStatus = ones(numel(BreakPipe_order),168*2)*2;%û���޸�����ʱģ����̡�
else
    PipeStatus = PipeStatus2;
end
duration_one = numel(PipeStatus(1,:));
a = EPS_net_EPANETx64PDD( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
    duration_one);
a.Run_debug;
system_serviceability_cell = a.system_serviceability;
activity_cell = a.activity;
results = a;
Fitness = sum(cell2mat(system_serviceability_cell))/duration_one;
end
function [Fit,fitvalue,ENrun_number_recovery]=calfitvalue4_recovery(indivi_isolation,pop,BreakPipe_order,RepairCrew,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
    ~,net_data,...
    ~,...
    generation_dir_i,...
    output_net_filename_inp,pipe_relative)%,...
popsize = numel(pop(:,1));
Fitness= zeros(popsize,1);
fitvalue=cell(popsize,15);
ENrun_number_recovery = zeros(popsize,1);
for individual_i=1:popsize
    individual_dir_i=[generation_dir_i,'\',num2str(individual_i),'\'];
    mkdir(individual_dir_i)
    BreakPipePriority=pop(individual_i,:);
    %fit5
    [Fitness(individual_i),...
        ~,...
        ~,...
        system_serviceability_cell,...
        ~,results_recovery]...
        =fit7_recovery...
        (indivi_isolation,BreakPipePriority,...
        BreakPipe_order,RepairCrew,...
        Dp_Inspect_mat,...
        Dp_Repair_mat,Dp_Travel_mat,...
        net_data,...
        individual_dir_i,...
        output_net_filename_inp,...
        pipe_relative,...
        crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%������Ⱥ������Ӧ��
    ENrun_number_recovery(individual_i) = results_recovery.ENrun_num;
end
Fit = Fitness;
fitvalue{1,1} = system_serviceability_cell;
end
function [Fitness,...
    BreakPipe_result,...
    RepairCrew_result,...
    system_serviceability_cell,...
    activity_cell,results]...
    =fit7_recovery...
    (indivi_isolation,BreakPipeRecoveryPriority,...
    BreakPipe_order,RepairCrew,...
    Dp_Inspect_mat,...
    Dp_Repair_mat,Dp_Travel_mat,...
    net_data,...
    output_result_dir,...
    output_net_filename_inp,...
    pipe_relative,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel)%������Ⱥ������Ӧ��
% funcName = 'fit7_recovery';
BreakPipePriority_cell = num2cell(indivi_isolation');
DamagePipePriority_cell = num2cell(BreakPipeRecoveryPriority');
[BreakPipe_result,RepairCrew_result,Active_result]=priorityList2schedule9(BreakPipePriority_cell,DamagePipePriority_cell,RepairCrew,num2cell(BreakPipe_order),...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%�����޸���������ʱ����������޸��ֿ��Ĳ��� from 'random\'
% [PipeStatus2,PipeStatusChange]=schedule2pipestatus4(BreakPipe_result);%����ʱ������ɹܵ�״̬����
% if isempty(PipeStatus2)
%     PipeStatus = ones(numel(BreakPipe_order),168*2)*2;%û���޸�����ʱģ����̡�
% else
%     PipeStatus = PipeStatus2;
% end


t = Schedule(Active_result,BreakPipe_result);
t.crew_origin = RepairCrew;
t.pipe_origin = net_data{5,2}(:,1);
t.Run
PipeStatus = t.time_schedule_pipeStatus';
PipeStatusChange = t.time_schedule_pipeStatusChange';
duration_one = numel(PipeStatus(1,:));
a = EPS_net_EPANETx64PDD( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
    duration_one);
a.Run_debug;
system_serviceability_cell = a.system_serviceability;
activity_cell = a.activity;
results = a;
% a.delete
Fitness = sum(cell2mat(system_serviceability_cell))/duration_one;
end