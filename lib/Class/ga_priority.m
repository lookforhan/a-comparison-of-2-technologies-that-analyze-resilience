classdef ga_priority < handle
    %gs_priority 用遗传算法获得最优修复次序
    %   增加接力优化的功能
    %   a = ga_priority();
    %   a.
    %   a.
    %   ...
    %   a.run_process_isolation
    properties
        Out_dir
        Net_inp
    end
    properties %input--transfer
        Damage_pipe_info % 破坏信息 % 过路变量
        Net_data % 管网信息  %过路变量
        Pipe_relative % 管道相关性
        Epa_format % 管网读写格式
        Isolation_time_mat % 隔离时间
        Replacement_time_mat % 替换时间
        Displacement_time_mat % 移动时间
    end
    properties % input-no use
        Crews
        Crews_Start_Time % 队伍开始工作时间
        Crews_Replacement_Efficiency % 队伍替换效率
        Crews_Isolation_Efficiency % 队伍隔离效率
        Crews_Displacement_Efficiency % 队伍移动效率
    end
    properties %  input process 1
        Pop_isolation_init = [] % 隔离初始种群
        Popsize_process_isolation % 种群规模
        Generation_Nmax_process_isolation % 第1阶段最大进化代数
        Probability_crossover_isolation % 交叉概率
        Probability_mutation_isolation % 变异概率
    end
    properties %input process 2
        Pop_replacement_init = [] % 替换初始种群
        Popsize_process_replacement
        Generation_Nmax_process_replacement % 第2阶段最大进化代数
        Probability_crossover_replacement % 交叉概率
        Probability_mutation_replacement % 变异概率
    end
    %     properties(Dependent,SetAccess = private) %get
    %         Isolation_Pipe_order % 需要隔离的管道在管网种的次序
    %     end
    properties % output
        Results
        Best_indivi_isolation
    end
    methods
        function obj = ga_priority()
            %gs_priority 构造此类的实例
            %   此处显示详细说明
            obj.Results=struct('errcode',0,'isolation_fit_record',[],'isolation_pop_record',[],'best_indivi_isolation',[],...
                'replacement_fit_record',[],'replacement_pop_record',[],'best_indivi_replacement',[]);%输出参数用结构体表达
        end
        function run_process_isolation(obj)
            disp('=====process isolation=====')
            damage_pipe_info = obj.Damage_pipe_info;
            popsize = obj.Popsize_process_isolation ;
            generation_Nmax = obj.Generation_Nmax_process_isolation;
            probability_crossover = obj.Probability_crossover_isolation;
            probability_mutation = obj.Probability_mutation_isolation;
            BreakPipe_order = damage_pipe_info{1}(damage_pipe_info{3}==2);%需要隔离的管道
            if isempty(obj.Pop_isolation_init) %如果未指定初始种群，则初始种群为随机产生
                [pop_isolation_init]=initpop4(popsize,BreakPipe_order);
            else
                pop_isolation_init = obj.Pop_isolation_init;
            end
            pop_init = pop_isolation_init;
            process_1_dir = [obj.Out_dir,'isolation\'];
            result = obj.genetic_algorithm_process_isolation (pop_init,generation_Nmax,probability_crossover,probability_mutation,...
                process_1_dir);
            obj.Results.isolation_fit_record = result.fit_record;
            obj.Results.isolation_pop_record = result.pop_record;
            obj.Results.best_indivi_isolation = result.best_indivi;
            obj.Results.isolation_ENrun_num = result.ENrun_num;
        end
        function run_process_replacement(obj)
            disp('=====process replacement=====')
            damage_pipe_info = obj.Damage_pipe_info;
            popsize = obj.Popsize_process_replacement ;
            generation_Nmax = obj.Generation_Nmax_process_replacement;
            probability_crossover = obj.Probability_crossover_replacement;
            probability_mutation = obj.Probability_mutation_replacement;
            DamagePipe_order = damage_pipe_info{1};%需要替换/维修的管道
            if isempty(obj.Pop_replacement_init) %如果未指定初始种群，则初始种群为随机产生
                [pop_replacement_init]=initpop4(popsize,DamagePipe_order);
            else
                pop_replacement_init = obj.Pop_replacement_init;
            end
            pop_init = pop_replacement_init;
            process_1_dir = [obj.Out_dir,'replacement\'];
            result = obj.genetic_algorithm_process_replacement (pop_init,generation_Nmax,probability_crossover,probability_mutation,...
                process_1_dir);
            obj.Results.replacement_fit_record = result.fit_record;
            obj.Results.replacement_pop_record = result.pop_record;
            obj.Results.best_indivi_replacement = result.best_indivi;
            obj.Results.replacement_ENrun_num = result.ENrun_num;
            obj.Results.system_serviceability = result.system_serviceability;
        end
        
    end
    
    methods
        function result = genetic_algorithm_process_isolation(obj,pop_init,generation_Nmax,probability_crossover,probability_mutation,...
                output_dir)
            % genetic_algorithm 遗传算法
            % obj 对象
            % pipe_oredr 需要排序的管道在管网中的位置
            % pop_init 初始种群
            % generation_Nmax 进化代数
            % probability_crossover 交叉概率
            % probability_mutation 变异概率
            % result = obj.genetic_algorithm (pipe_order,pop_init,generation_Nmax,probability_crossover,robability_mutation,output_dir)
            popsize = numel(pop_init(:,1));
            pop_record = pop_init;%记录个体
            Fit_max = zeros(generation_Nmax,1);
            Fit_mean = zeros(generation_Nmax,1);
            pop_uniq = pop_init;
            Fit_record = zeros(popsize*generation_Nmax,1);
            ENrun_number_init = zeros(popsize,generation_Nmax);
            
            damage_pipe_info = obj.Damage_pipe_info;
            RepairCrew =obj.Crews;
            Dp_Inspect_mat = obj.Isolation_time_mat;
            Dp_Repair_mat = obj.Replacement_time_mat;
            Dp_Travel_mat = obj.Displacement_time_mat;
            crewStartTime = obj.Crews_Start_Time;
            crewEfficiencyRecovery = obj.Crews_Replacement_Efficiency;
            crewEfficiencyIsolation = obj.Crews_Isolation_Efficiency;
            crewEfficiencyTravel = obj.Crews_Displacement_Efficiency;
            net_data = obj.Net_data;
            EPA_format =obj.Epa_format;
            pipe_relative = obj.Pipe_relative;
            output_net_filename_inp = obj.Net_inp;
            for generation_i = 1:generation_Nmax
                generation_dir_i=[output_dir,'遗传第',num2str(generation_i),'代\'];
                if ~isempty(pop_uniq)
                    [Fit_uniq,~,ENrun_number]=calfitvalue4_isolation(pop_uniq,damage_pipe_info{1},RepairCrew,...
                        Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
                        crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
                        damage_pipe_info,net_data,...
                        EPA_format,...
                        generation_dir_i,...文件路径
                        output_net_filename_inp,pipe_relative);%,...
                else
                    Fit_uniq = [];
                    ENrun_number =[];
                end
                if generation_i==1
                    Fit_init = Fit_uniq;
                    Fit_record((generation_i-1)*popsize+1:(generation_i-1)*popsize+popsize)= Fit_init;
                    pop_old = pop_init;
                    ENrun_number_init(:,generation_i) = ENrun_number;
                else
                    %         keyboard
                    Fit_init(:) = 0;
                    for i_new_indivi = 1:num_new_indivi
                        Fit_init(logical(locb_new_indivi(:,i_new_indivi))) = Fit_uniq(i_new_indivi);%将计算出来的适应度值赋值给相应个体对应的位置。
                        ENrun_number_init(find(locb_new_indivi(:,i_new_indivi)==1,1),generation_i) = ENrun_number(i_new_indivi);%将计算过程中的水力平差次数赋值给相应个体，相同个体只赋值给第一个。
                    end
                    
                    for i_not_new_indivi = 1:num_not_new_indivi
                        Fit_init(logical(locb_not_new_indivi(:,i_not_new_indivi))) =Fit_record(locb_not_new_indivi_fit(i_not_new_indivi));
                    end
                    Fit_record((generation_i-1)*popsize+1:(generation_i-1)*popsize+popsize) = Fit_init;
                    pop_old = newPop_isolation;
                    % pop_uniq(lia1,:)
                end
                %     keyboard
                Fit_max(generation_i,1) = max(Fit_init);
                Fit_mean(generation_i,1) = mean(Fit_init);
                
                
                [ newPop_isolation ] = ga_process( pop_old,Fit_init,probability_mutation,probability_crossover );
                [ pop_new,pop_new_not,new_individual_record_mat ] = ga_unique_individual3( newPop_isolation,pop_record );
                
                
                [pop_new_uniq,~,~] = unique(pop_new,'rows','stable');% 对没有进行过水力分析的个体进行检查，剔除重复个体。
                [pop_new_not_uniq,~,~] = unique(pop_new_not,'rows','stable');%
                pop_uniq = pop_new_uniq;
                pop_record=new_individual_record_mat;
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
                    [~,locb_not_new_indivi_fit(i_not_new_indivi)] = ismember(pop_new_not_uniq(i_not_new_indivi,:) ,pop_record(1:end-popsize,:),'rows');
                end
                timeCost = toc;
                disp(['===========:遗传第',num2str(generation_i),'代；耗时',num2str(timeCost),'S========','适应度最大值：',num2str(Fit_max(generation_i,1)),...
                    '；==适应度平均值：',num2str(Fit_mean(generation_i,1))]);
                % 绘图
                %                 f = figure;
                x = 1:generation_i;
                y =  Fit_max(1:generation_i);
                z = Fit_mean(1:generation_i);
                p_max = plot (x,y);
                p_max.XData = x;
                p_max.YData = y;
                hold on
                p_mean = plot(x,z);
                p_mean.XData = x;
                p_mean.YData = z;
            end
            
            [~,a2] = max(Fit_record);
            best_indivi_isolation = pop_record(a2,:);
            result.fit_record = Fit_record;
            result.pop_record = pop_record(1:end-popsize,:);
            result.best_indivi = best_indivi_isolation;
            result.ENrun_num = ENrun_number_init;
            obj.Best_indivi_isolation = best_indivi_isolation;
        end
        function result = genetic_algorithm_process_replacement(obj,pop_init,generation_Nmax,probability_crossover,probability_mutation,...
                output_dir)
            % genetic_algorithm 遗传算法
            % obj 对象
            % pipe_oredr 需要排序的管道在管网中的位置
            % pop_init 初始种群
            % generation_Nmax 进化代数
            % probability_crossover 交叉概率
            % probability_mutation 变异概率
            % result = obj.genetic_algorithm (pipe_order,pop_init,generation_Nmax,probability_crossover,robability_mutation,output_dir)
            popsize = numel(pop_init(:,1));
            pop_record = pop_init;%记录个体
            Fit_max = zeros(generation_Nmax,1);
            Fit_mean = zeros(generation_Nmax,1);
            pop_uniq = pop_init;
            Fit_record = zeros(popsize*generation_Nmax,1);
            ENrun_number_init = zeros(popsize,generation_Nmax);
            best_indivi = obj.Results.best_indivi_isolation;
            damage_pipe_info = obj.Damage_pipe_info;
            RepairCrew =obj.Crews;
            Dp_Inspect_mat = obj.Isolation_time_mat;
            Dp_Repair_mat = obj.Replacement_time_mat;
            Dp_Travel_mat = obj.Displacement_time_mat;
            crewStartTime = obj.Crews_Start_Time;
            crewEfficiencyRecovery = obj.Crews_Replacement_Efficiency;
            crewEfficiencyIsolation = obj.Crews_Isolation_Efficiency;
            crewEfficiencyTravel = obj.Crews_Displacement_Efficiency;
            net_data = obj.Net_data;
            EPA_format =obj.Epa_format;
            pipe_relative = obj.Pipe_relative;
            output_net_filename_inp = obj.Net_inp;
            for generation_i = 1:generation_Nmax
                generation_dir_i=[output_dir,'遗传第',num2str(generation_i),'代\'];
                if ~isempty(pop_uniq)
                    [Fit_uniq,system_serviceability_uniq,ENrun_number]=calfitvalue4_recovery(best_indivi,pop_uniq,damage_pipe_info{1},RepairCrew,...
                        Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
                        crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
                        damage_pipe_info,net_data,...
                        EPA_format,...
                        generation_dir_i,...文件路径
                        output_net_filename_inp,pipe_relative);%,...
                else
                    Fit_uniq = [];
                    ENrun_number =[];
                    system_serviceability_uniq = [];
                end
                if generation_i==1
                    Fit_init = Fit_uniq;
                    Fit_record((generation_i-1)*popsize+1:(generation_i-1)*popsize+popsize)= Fit_init;
                    pop_old = pop_init;
                    ENrun_number_init(:,generation_i) = ENrun_number;
                    system_serviceability_init_record(:,generation_i) = system_serviceability_uniq;
                else
                   
                    Fit_init(:) = 0;
                    for i_new_indivi = 1:num_new_indivi
                        Fit_init(logical(locb_new_indivi(:,i_new_indivi))) = Fit_uniq(i_new_indivi);%将计算出来的适应度值赋值给相应个体对应的位置。
                        ENrun_number_init(find(locb_new_indivi(:,i_new_indivi)==1,1),generation_i) = ENrun_number(i_new_indivi);%将计算过程中的水力平差次数赋值给相应个体，相同个体只赋值给第一个。
                        system_serviceability_init_record(find(locb_new_indivi(:,i_new_indivi)==1,1),generation_i) = system_serviceability_uniq(i_new_indivi);
                    end
                    
                    for i_not_new_indivi = 1:num_not_new_indivi
                        Fit_init(logical(locb_not_new_indivi(:,i_not_new_indivi))) =Fit_record(locb_not_new_indivi_fit(i_not_new_indivi));
                    end
                    Fit_record((generation_i-1)*popsize+1:(generation_i-1)*popsize+popsize) = Fit_init;
                    pop_old = newPop;
                    % pop_uniq(lia1,:)
                end
                %     keyboard
                Fit_max(generation_i,1) = max(Fit_init);
                Fit_mean(generation_i,1) = mean(Fit_init);
                
                
                [ newPop ] = ga_process( pop_old,Fit_init,probability_mutation,probability_crossover );
                [ pop_new,pop_new_not,new_individual_record_mat ] = ga_unique_individual3( newPop,pop_record );
                
                
                [pop_new_uniq,~,~] = unique(pop_new,'rows','stable');% 对没有进行过水力分析的个体进行检查，剔除重复个体。
                [pop_new_not_uniq,~,~] = unique(pop_new_not,'rows','stable');%
                pop_uniq = pop_new_uniq;
                pop_record=new_individual_record_mat;
                num_new_indivi = numel(pop_new_uniq(:,1));
                locb_new_indivi = zeros(numel(newPop(:,1)),num_new_indivi);
                for i_new_indivi = 1:num_new_indivi
                    [locb_new_indivi(:,i_new_indivi) ] = ismember(newPop,pop_new_uniq(i_new_indivi,:) ,'rows');
                end
                num_not_new_indivi = numel(pop_new_not_uniq(:,1));
                locb_not_new_indivi = zeros(numel(newPop(:,1)),num_not_new_indivi);
                locb_not_new_indivi_fit = zeros(1,num_not_new_indivi);
                for i_not_new_indivi = 1:num_not_new_indivi
                    [locb_not_new_indivi(:,i_not_new_indivi) ] = ismember(newPop,pop_new_not_uniq(i_not_new_indivi,:) ,'rows');
                    [~,locb_not_new_indivi_fit(i_not_new_indivi)] = ismember(pop_new_not_uniq(i_not_new_indivi,:) ,pop_record(1:end-popsize,:),'rows');
                end
                timeCost = toc;
                disp(['===========:遗传第',num2str(generation_i),'代；耗时',num2str(timeCost),'S========','适应度最大值：',num2str(Fit_max(generation_i,1)),...
                    '；==适应度平均值：',num2str(Fit_mean(generation_i,1))]);
                % 绘图
                %                 f = figure;
                x = 1:generation_i;
                y =  Fit_max(1:generation_i);
                z = Fit_mean(1:generation_i);
                p_max = plot (x,y);
                p_max.XData = x;
                p_max.YData = y;
                hold on
                p_mean = plot(x,z);
                p_mean.XData = x;
                p_mean.YData = z;
            end
            
            [~,a2] = max(Fit_record);
            best_indivi = pop_record(a2,:);
            result.fit_record = Fit_record;
            result.pop_record = pop_record(1:end-popsize,:);
            result.best_indivi = best_indivi;
            result.ENrun_num = ENrun_number_init;
            result.system_serviceability = system_serviceability_init_record;
        end
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
    %     mkdir(individual_dir_i)
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
        crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%评价种群个体适应度
    ENrun_number(individual_i) = results_isolation.ENrun_num;
end
Fit = Fitness;
end
function [Fit,system_serviceability_cell,ENrun_number_recovery,result_all]=calfitvalue4_recovery(indivi_isolation,pop,BreakPipe_order,RepairCrew,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
    ~,net_data,...
    ~,...
    generation_dir_i,...
    output_net_filename_inp,pipe_relative)%,...
popsize = numel(pop(:,1));
Fitness= zeros(popsize,1);
% fitvalue=cell(popsize,1);
ENrun_number_recovery = zeros(popsize,1);
result_all = cell(popsize,2);
system_serviceability_cell= cell(popsize,1);
for individual_i=1:popsize
    individual_dir_i=[generation_dir_i,'\',num2str(individual_i),'\'];
    %     mkdir(individual_dir_i)
    BreakPipePriority=pop(individual_i,:);
    %fit5
    [Fitness(individual_i),...
        ~,...
        ~,...
        ~,...
        ~,results_recovery,schedule_recovery]...
        =fit8_recovery...
        (indivi_isolation,BreakPipePriority,...
        BreakPipe_order,RepairCrew,...
        Dp_Inspect_mat,...
        Dp_Repair_mat,Dp_Travel_mat,...
        net_data,...
        individual_dir_i,...
        output_net_filename_inp,...
        pipe_relative,...
        crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,0);%评价种群个体适应度
    ENrun_number_recovery(individual_i) = results_recovery.ENrun_num;
    result_all{individual_i,1} = results_recovery;
    result_all{individual_i,2} = schedule_recovery;
    system_serviceability_cell{individual_i,1} = results_recovery.system_serviceability;
end
Fit = Fitness;
%  fitvalue{1,1} = system_serviceability_cell;
% fitvalue{1,2} = result_all;
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
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel)%评价种群个体适应度
% funcName = 'fit7_isolation';
BreakPipePriority_cell = num2cell(BreakPipePriority');
DamagePipePriority_cell = num2cell(BreakPipe_order);
[BreakPipe_result,RepairCrew_result]=priorityList2schedule10_2_step_one(BreakPipePriority_cell,RepairCrew,DamagePipePriority_cell,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,output_result_dir,...
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel);%根据修复次序生成时间表，隔离与修复分开的策略 from 'random\'
[PipeStatus2,PipeStatusChange]=schedule2pipestatus5_isolation(BreakPipe_result,BreakPipe_order);%根据时间表生成管道状态矩阵
if isempty(PipeStatus2)
    PipeStatus = ones(numel(BreakPipe_order),168*2)*2;%没有修复的延时模拟过程。
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