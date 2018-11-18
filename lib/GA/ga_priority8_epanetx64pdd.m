% 新建一个变量，记录模拟过的个体，并比较
% 当采用epanetx64pdd.dll时，改写的遗传府过程。在ga_priority6.m的基础上修改。
function [pop_isolation_record,Fit_record]...
    =ga_priority8_epanetx64pdd(popsize,generation_length,pc,pm,...种群大小，进化代数，交叉概率，变异概率
    out_dir,....输出目录
    RepairCrew,...修复队伍，
    damage_pipe_info,net_data,pipe_relative,...破坏信息，管网信息，破坏管道相关新建管道
    EPA_format,...node_original_data,system_original_L,...EPA格式，节点原本数据，系统原本管道长度
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...检查时间，修复时间，移动时间
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
    output_net_filename_inp)%,...
% 编码
DamagePipe_order = damage_pipe_info{1};%需要修复的管道
BreakPipe_order = damage_pipe_info{1}(damage_pipe_info{3}==2);%需要隔离的管道
%
[pop_isolation_init,pop_replacement_init]=initpop3(popsize,BreakPipe_order,DamagePipe_order);
%%%%% 判断初始种群中是否存在重复个体

[c_isolationBreak,ia_isolationBreak,ic_isolationBreak] = unique(pop_isolation_init,'rows');%检查隔离次序中个体是否存在重复
[c_replacement,ia_replacement,ic_replacement] = unique(pop_replacement_init,'rows');%检查修复次序中个体是否存在重复
pop_isolation_uniq = c_isolationBreak;
pop_isolation_record = pop_isolation_uniq;%记录个体

Fit_max = zeros(generation_length,1);
Fit_mean = zeros(generation_length,1);
for generation_i = 1:generation_length
    generation_dir_i=[out_dir,'遗传第',num2str(generation_i),'代\'];
    mkdir(generation_dir_i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%开始计算第i代
    if ~isempty(pop_isolation_uniq)
        
    
   [Fit_uniq,fitvalue]=calfitvalue4(pop_isolation_uniq,BreakPipe_order,RepairCrew,...
     Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
     crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
    damage_pipe_info,net_data,...
    EPA_format,...
    generation_dir_i,...
output_net_filename_inp,pipe_relative)%,...
    else
        generation_i = generation_length+1;
        disp('haha')
        break
    end
if generation_i==1
Fit_init = Fit_uniq(ic_isolationBreak);
Fit_record = Fit_init;

else
Fit_init(locb1) = Fit_uniq;
Fit_init(locb2) = Fit_record(locb3);
Fit_record = [Fit_record;Fit_init];
end
Fit_max(generation_i,1) = max(Fit_init);
Fit_mean(generation_i,1) = mean(Fit_init);
if generation_i>10
    if rem(generation_i,5)==0
    error = Fit_mean{generation_i,1}-Fit_mean{generation_i-5,1};
    if abs(error)<ga_doa
        disp(num2str(generation_i))
        disp(['均值误差为',num2str(error)])
        disp(['遗传代数为',num2str(generation_i)])
        break
    end
    end
end
if generation_i==generation_length
    disp(['遗传代数为',num2str(generation_i)])
    break
end
% % ga 操作
[ newPop_isolation ] = ga_process( pop_isolation_init,Fit_init,pm,pc );
[ pop_uniq,pop_uniq_not,new_individual_record_mat ] = ga_unique_individual3( newPop_isolation,pop_isolation_record );
[lia1,locb1] = ismember(pop_uniq,newPop_isolation,'rows')
[lia2,locb2] = ismember(pop_uniq_not,newPop_isolation,'rows')
[lia3,locb3] = ismember(pop_uniq_not,pop_isolation_record,'rows')
pop_isolation_uniq = pop_uniq;
pop_isolation_record=new_individual_record_mat;



if isempty(pop_uniq)
    disp('没有产生新个体')
    disp(['遗传代数为',num2str(generation_i)])
    break
end

end
            

   
end