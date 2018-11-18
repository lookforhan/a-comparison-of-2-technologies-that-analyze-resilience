%%
function [Fitness,best_pop,BreakPipe_result,RepairCrew_result,...
    F,system_L,system_serviceability,node_serviceability,node2_serviceability,...
    node_calculate_dem,node_calculate_pre,timeStep_end,...
    y,y1,x1]...
    =ga_priority(popsize,generation_length,pc,pm,...��Ⱥ��С������������������ʣ��������
    MC_simulate_result_dir,MC_i,Nmax_MC,...�ļ��У�ģ����������ģ�����
    BreakPipe_order,RepairCrew,...�ƻ��ܵ����޸����飬
    damage_pipe_info,net_data,...�ƻ���Ϣ��������Ϣ��
    EPA_format,...node_original_data,system_original_L,...EPA��ʽ���ڵ�ԭ�����ݣ�ϵͳԭ���ܵ�����
    circulation_num,doa,Hmin,Hdes,...PDD�������������ȣ���Сˮѹ����Ҫˮѹ
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    output_net_filename_inp,pipe_relative)%,...���ʱ�䣬�޸�ʱ�䣬�ƶ�ʱ��
    ...pressure_cell,demand_cell...%��ǰ�������������
%     )%
%%
 
        [pop]=initpop(popsize,BreakPipe_order);%���ɳ�ʼ��Ⱥ---0104�汾����initpop2.m
        best_pop=cell(Nmax_MC,generation_length);%?
        pop_mat=zeros(numel(pop{1}),numel(pop));%�þ����ʾpop
        newpop_mutation_mat=zeros(numel(pop{1}),numel(pop)-2);%�þ����ʾpop_mutation
        new_a_loc=zeros(numel(pop{1}),1);%?
        %% ������Ӧ�Ⱥ���
        generation_i=1;
        generation_dir_i=[MC_simulate_result_dir,'\�Ŵ���',num2str(generation_i),'��'];
        mkdir(generation_dir_i);
%         node_original_dem=cell2mat(node_original_data(:,2));%�ڵ�ԭ������ˮ��
%         original_junction_num=numel( node_original_dem);%�ڵ����
        [fitvalue_0,best_pop{MC_i,generation_i}]=calfitvalue(pop,RepairCrew,BreakPipe_order,...
            Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
            MC_i,...original_junction_num,
            damage_pipe_info,net_data,MC_simulate_result_dir,...
            EPA_format,...node_original_data,
            circulation_num,doa,Hmin,Hdes,...node_original_dem,system_original_L,
            generation_dir_i,generation_i,...
            output_net_filename_inp,pipe_relative);%,...
%             pressure_cell,demand_cell);%������Ӧ��
        Fitvalue=linear_normalized(fitvalue_0(:,1),100,2.5);
        
        fitvalue_1=fitvalue_0;%��ʼֵ��fitvalue_0����
        fitvalue_2=fitvalue_0(:,1);
        y1(:,1)=cell2mat(fitvalue_1(:,1));%��Ӧ��ֵ��ɢ��ͼ
        x1(:,1)=ones(numel(Fitvalue),1);%��Ӧ��ֵ��ɢ��ͼ
        y(1)=max(y1(:,1));%��¼�������
        pop_1=pop;
        for generation_i=2:generation_length
            disp(['main1222','��',num2str(MC_i),'/',num2str(Nmax_MC),'ģ��','�Ŵ���',num2str(generation_i),'/',num2str(generation_length),'��'])
            generation_dir_i=[MC_simulate_result_dir,'\�Ŵ���',num2str(generation_i),'��'];
            mkdir(generation_dir_i);
            
            %             y(generation_i)=best_pop{MC_i,generation_i}{1};%��¼��Ѹ���
            [newpop_section,new_fitvalue,best_indiv,max_fitness]=selection(pop_1,Fitvalue,fitvalue_2);%% ѡ��
            
            best_individual=best_indiv;%���Ÿ���
            newpop_cross_fitvalue=new_fitvalue;%��������Ⱥ�е�˳��û�б䣬���Ӧ����Ӧ��ֵû�б�
            [newpop_cross,record_cross]=crossover5(newpop_section,pc);%����
            newpop_cross_fitvalue(record_cross==1)=0;%�ı��˵ĸ�����Ӧ��ֵ��ʱ��Ϊ��
            newpop_mutation_fitvalue=newpop_cross_fitvalue;%��������Ⱥ�е�˳��û�б䣬���Ӧ����Ӧ��ֵû�б�
            [newpop_mutation,record_mutation]=mutation2(newpop_cross,pm);%����
            newpop_mutation_fitvalue(record_mutation==1)=0;%��������ĸ�����Ӧ��ֵ��ʱ��Ϊ��
            % ------------------------------------------------------------------
            % ���������ɵĸ���
            
            
            [lia1,b]=find(newpop_mutation_fitvalue==0);%��Ӧ��ֵΪ0�ĸ���Ϊ�����ı�ĸ���
            %             lia1=find(lia==0);
            if ~isempty(lia1)%�иı�ĸ���
                new_add_pop=newpop_mutation(lia1);%������Ⱥ�¸���
                pop_c=new_add_pop;%����������Ⱥ���Ƹ�pop�����������ɵĸ������Ӧ��
                pop_1=[newpop_mutation;best_indiv;best_indiv];
                [fitvalue_0,best_pop{MC_i,generation_i}]=calfitvalue(pop_c,RepairCrew,BreakPipe_order,...
                    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
                    MC_i,...original_junction_num,
                    damage_pipe_info,net_data,MC_simulate_result_dir,...
                    EPA_format,...node_original_data,
                    circulation_num,doa,Hmin,Hdes,...node_original_dem,system_original_L,
                    generation_dir_i,generation_i,...pressure_cell,demand_cell
                    output_net_filename_inp,...
    pipe_relative);%������Ӧ��
                fitvalue_2=num2cell([newpop_mutation_fitvalue;max_fitness;max_fitness]);
                fitvalue_2(lia1)=fitvalue_0(:,1);
            else%�޸ı�ĸ���
                disp('main_1222:û�������¸���')
                pop_1=[newpop_mutation;best_indiv;best_indiv];
                fitvalue_2=num2cell([newpop_mutation_fitvalue;max_fitness;max_fitness]);
                best_pop{MC_i,generation_i}=best_indiv{1};
            end
            Fitvalue=linear_normalized(fitvalue_2,100,2.5);
            %             y1=fitvalue_2;
            %             x1=generation_i;
            y(generation_i)=max_fitness;%��¼��Ѹ���
            y1(:,generation_i)=cell2mat(fitvalue_2);%ɢ��ͼ
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
    pipe_relative,'on');%������Ⱥ������Ӧ��
end