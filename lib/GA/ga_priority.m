%%
function [Fitness,best_pop,BreakPipe_result,RepairCrew_result,...
    F,system_L,system_serviceability,node_serviceability,node2_serviceability,...
    node_calculate_dem,node_calculate_pre,timeStep_end,...
    y,y1,x1]...
    =ga_priority(popsize,generation_length,pc,pm,...种群大小，进化代数，交叉概率，变异概率
    MC_simulate_result_dir,MC_i,Nmax_MC,...文件夹，模拟次数，最大模拟次数
    BreakPipe_order,RepairCrew,...破坏管道，修复队伍，
    damage_pipe_info,net_data,...破坏信息，管网信息，
    EPA_format,...node_original_data,system_original_L,...EPA格式，节点原本数据，系统原本管道长度
    circulation_num,doa,Hmin,Hdes,...PDD迭代次数，精度，最小水压，需要水压
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    output_net_filename_inp,pipe_relative)%,...检查时间，修复时间，移动时间
    ...pressure_cell,demand_cell...%提前定义的两个变量
%     )%
%%
 
        [pop]=initpop(popsize,BreakPipe_order);%生成初始种群---0104版本采用initpop2.m
        best_pop=cell(Nmax_MC,generation_length);%?
        pop_mat=zeros(numel(pop{1}),numel(pop));%用矩阵表示pop
        newpop_mutation_mat=zeros(numel(pop{1}),numel(pop)-2);%用矩阵表示pop_mutation
        new_a_loc=zeros(numel(pop{1}),1);%?
        %% 计算适应度函数
        generation_i=1;
        generation_dir_i=[MC_simulate_result_dir,'\遗传第',num2str(generation_i),'代'];
        mkdir(generation_dir_i);
%         node_original_dem=cell2mat(node_original_data(:,2));%节点原本的需水量
%         original_junction_num=numel( node_original_dem);%节点个数
        [fitvalue_0,best_pop{MC_i,generation_i}]=calfitvalue(pop,RepairCrew,BreakPipe_order,...
            Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
            MC_i,...original_junction_num,
            damage_pipe_info,net_data,MC_simulate_result_dir,...
            EPA_format,...node_original_data,
            circulation_num,doa,Hmin,Hdes,...node_original_dem,system_original_L,
            generation_dir_i,generation_i,...
            output_net_filename_inp,pipe_relative);%,...
%             pressure_cell,demand_cell);%计算适应度
        Fitvalue=linear_normalized(fitvalue_0(:,1),100,2.5);
        
        fitvalue_1=fitvalue_0;%初始值由fitvalue_0赋予
        fitvalue_2=fitvalue_0(:,1);
        y1(:,1)=cell2mat(fitvalue_1(:,1));%适应度值的散点图
        x1(:,1)=ones(numel(Fitvalue),1);%适应度值的散点图
        y(1)=max(y1(:,1));%记录最佳韧性
        pop_1=pop;
        for generation_i=2:generation_length
            disp(['main1222','第',num2str(MC_i),'/',num2str(Nmax_MC),'模拟','遗传第',num2str(generation_i),'/',num2str(generation_length),'代'])
            generation_dir_i=[MC_simulate_result_dir,'\遗传第',num2str(generation_i),'代'];
            mkdir(generation_dir_i);
            
            %             y(generation_i)=best_pop{MC_i,generation_i}{1};%记录最佳个体
            [newpop_section,new_fitvalue,best_indiv,max_fitness]=selection(pop_1,Fitvalue,fitvalue_2);%% 选择
            
            best_individual=best_indiv;%最优个体
            newpop_cross_fitvalue=new_fitvalue;%个体在种群中的顺序没有变，其对应的适应度值没有变
            [newpop_cross,record_cross]=crossover5(newpop_section,pc);%交配
            newpop_cross_fitvalue(record_cross==1)=0;%改变了的个体适应度值暂时改为零
            newpop_mutation_fitvalue=newpop_cross_fitvalue;%个体在种群中的顺序没有变，其对应的适应度值没有变
            [newpop_mutation,record_mutation]=mutation2(newpop_cross,pm);%变异
            newpop_mutation_fitvalue(record_mutation==1)=0;%发生变异的个体适应度值暂时改为零
            % ------------------------------------------------------------------
            % 查找新生成的个体
            
            
            [lia1,b]=find(newpop_mutation_fitvalue==0);%适应度值为0的个体为发生改变的个体
            %             lia1=find(lia==0);
            if ~isempty(lia1)%有改变的个体
                new_add_pop=newpop_mutation(lia1);%产生种群新个体
                pop_c=new_add_pop;%将变异后的种群复制给pop，计算新生成的个体的适应度
                pop_1=[newpop_mutation;best_indiv;best_indiv];
                [fitvalue_0,best_pop{MC_i,generation_i}]=calfitvalue(pop_c,RepairCrew,BreakPipe_order,...
                    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
                    MC_i,...original_junction_num,
                    damage_pipe_info,net_data,MC_simulate_result_dir,...
                    EPA_format,...node_original_data,
                    circulation_num,doa,Hmin,Hdes,...node_original_dem,system_original_L,
                    generation_dir_i,generation_i,...pressure_cell,demand_cell
                    output_net_filename_inp,...
    pipe_relative);%计算适应度
                fitvalue_2=num2cell([newpop_mutation_fitvalue;max_fitness;max_fitness]);
                fitvalue_2(lia1)=fitvalue_0(:,1);
            else%无改变的个体
                disp('main_1222:没有生成新个体')
                pop_1=[newpop_mutation;best_indiv;best_indiv];
                fitvalue_2=num2cell([newpop_mutation_fitvalue;max_fitness;max_fitness]);
                best_pop{MC_i,generation_i}=best_indiv{1};
            end
            Fitvalue=linear_normalized(fitvalue_2,100,2.5);
            %             y1=fitvalue_2;
            %             x1=generation_i;
            y(generation_i)=max_fitness;%记录最佳个体
            y1(:,generation_i)=cell2mat(fitvalue_2);%散点图
            x1(:,generation_i)=ones(numel(Fitvalue),1)*generation_i;
            %  -------------------------------------------------------------------
            
            
        end
        [Fitness,BreakPipe_result,RepairCrew_result,F,system_L,system_serviceability,node_serviceability,node2_serviceability,node_calculate_dem,node_calculate_pre,timeStep_end]=fit4(best_individual{1},RepairCrew,BreakPipe_order,...
            Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...original_junction_num,
            damage_pipe_info,net_data,...
            MC_i,0,0,MC_simulate_result_dir,MC_simulate_result_dir,MC_simulate_result_dir,...
            EPA_format,...node_original_data,
            circulation_num,doa,Hmin,Hdes,...node_original_dem,system_original_L,...
            output_net_filename_inp,...
    pipe_relative,'on');%评价种群个体适应度
end