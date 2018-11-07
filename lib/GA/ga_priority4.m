% 新建一个变量，记录模拟过的个体，并比较
function [pop_record,Fit_record,generation_result]...
    =ga_priority4(popsize,generation_length,pc,pm,rate_best_pop,...种群大小，进化代数，交叉概率，变异概率
    MC_simulate_result_dir,MC_i,Nmax_MC,...文件夹，模拟次数，最大模拟次数
    BreakPipe_order,RepairCrew,...破坏管道，修复队伍，
    damage_pipe_info,net_data,...破坏信息，管网信息，
    EPA_format,...node_original_data,system_original_L,...EPA格式，节点原本数据，系统原本管道长度
    circulation_num,doa,Hmin,Hdes,...PDD迭代次数，精度，最小水压，需要水压
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    output_net_filename_inp,pipe_relative)%,...检查时间，修复时间，移动时间
    ...pressure_cell,demand_cell...%提前定义的两个变量
%     )%
best_pop_num = ceil(popsize*rate_best_pop);%实际分析的个体数；
% rng(5);
% pop_record = [];%记录个体
[pop_init]=initpop(popsize,BreakPipe_order);%生成初始种群---0104版本采用initpop2.m
%%%%% 判断初始种群中是否存在重复个体
individual_mat = [];
for i = 1:popsize
    individual_mat = [individual_mat,cell2mat(pop_init{i})];
end
[c1,ia1,ic1] = unique(individual_mat','rows');
pop_uniq = pop_init(ia1);
pop_record = pop_uniq;%记录个体
individual_record_mat=c1;
Fit_max = cell(generation_length,1);
Fit_mean = cell(generation_length,1);
for generation_i = 1:generation_length
    generation_dir_i=[MC_simulate_result_dir,'\遗传第',num2str(generation_i),'代\'];
    mkdir(generation_dir_i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%开始计算第i代
    if ~isempty(pop_uniq)
    Fit_uniq=[];
   [Fit_uniq,fitvalue]=calfitvalue2(pop_uniq,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    MC_i,...original_junction_num,
    damage_pipe_info,net_data,MC_simulate_result_dir,...
    EPA_format,...node_original_data,
    circulation_num,doa,Hmin,Hdes,...node_original_dem,system_original_L,
    generation_dir_i,generation_i,...
    output_net_filename_inp,pipe_relative);%,...
generation_result{generation_i,1}= fitvalue;
    end
if generation_i==1
Fit_init = Fit_uniq(ic1);
Fit_record = Fit_uniq;
else
    Fit_init_1=cell(0,1);
    Fit_init_1(uniq_loc_in_pop) = Fit_uniq;
    Fit_init_1(not_uniq_loc_in_pop) = Fit_record(not_uniq_loc_in_record);
    Fit_init = (Fit_init_1(uniq1_loc_in_init));
    Fit_record = [Fit_record;Fit_uniq];
end
Fit_max{generation_i,1} = max(cell2mat(Fit_init));
Fit_mean{generation_i,1} = mean(cell2mat(Fit_init));
if generation_i>=10
    error = Fit_mean{generation_i,1}-Fit_mean{generation_i-5,1};
    if error<0.01
        disp(num2str(generation_i))
        disp(['均值误差为',num2str(error)])
        break
    end
end
if generation_i==generation_length
    break
end
% % ga 操作
[ newPop ] = ga_process( pop_init,Fit_init,pm,pc );
[ pop_uniq,new_individual_record_mat,uniq_loc_in_pop,not_uniq_loc_in_pop,not_uniq_loc_in_record,uniq1_loc_in_init ]...
    = ga_unique_individual2( newPop,individual_record_mat );
individual_record_mat=new_individual_record_mat;
pop_init = newPop;
if isempty(pop_uniq)
    break
end
% % 个体重复判断
    if false %当达到某个条件时，终止遗传算法(最优值不变、平均值不变、不再生成新个体)
        break
    end
end
            

   
end