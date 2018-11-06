% �½�һ����������¼ģ����ĸ��壬���Ƚ�
function [pop_record,Fit_record,generation_result]...
    =ga_priority4(popsize,generation_length,pc,pm,rate_best_pop,...��Ⱥ��С������������������ʣ��������
    MC_simulate_result_dir,MC_i,Nmax_MC,...�ļ��У�ģ����������ģ�����
    BreakPipe_order,RepairCrew,...�ƻ��ܵ����޸����飬
    damage_pipe_info,net_data,...�ƻ���Ϣ��������Ϣ��
    EPA_format,...node_original_data,system_original_L,...EPA��ʽ���ڵ�ԭ�����ݣ�ϵͳԭ���ܵ�����
    circulation_num,doa,Hmin,Hdes,...PDD�������������ȣ���Сˮѹ����Ҫˮѹ
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    output_net_filename_inp,pipe_relative)%,...���ʱ�䣬�޸�ʱ�䣬�ƶ�ʱ��
    ...pressure_cell,demand_cell...%��ǰ�������������
%     )%
best_pop_num = ceil(popsize*rate_best_pop);%ʵ�ʷ����ĸ�������
% rng(5);
% pop_record = [];%��¼����
[pop_init]=initpop(popsize,BreakPipe_order);%���ɳ�ʼ��Ⱥ---0104�汾����initpop2.m
%%%%% �жϳ�ʼ��Ⱥ���Ƿ�����ظ�����
individual_mat = [];
for i = 1:popsize
    individual_mat = [individual_mat,cell2mat(pop_init{i})];
end
[c1,ia1,ic1] = unique(individual_mat','rows');
pop_uniq = pop_init(ia1);
pop_record = pop_uniq;%��¼����
individual_record_mat=c1;
Fit_max = cell(generation_length,1);
Fit_mean = cell(generation_length,1);
for generation_i = 1:generation_length
    generation_dir_i=[MC_simulate_result_dir,'\�Ŵ���',num2str(generation_i),'��\'];
    mkdir(generation_dir_i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ�����i��
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
        disp(['��ֵ���Ϊ',num2str(error)])
        break
    end
end
if generation_i==generation_length
    break
end
% % ga ����
[ newPop ] = ga_process( pop_init,Fit_init,pm,pc );
[ pop_uniq,new_individual_record_mat,uniq_loc_in_pop,not_uniq_loc_in_pop,not_uniq_loc_in_record,uniq1_loc_in_init ]...
    = ga_unique_individual2( newPop,individual_record_mat );
individual_record_mat=new_individual_record_mat;
pop_init = newPop;
if isempty(pop_uniq)
    break
end
% % �����ظ��ж�
    if false %���ﵽĳ������ʱ����ֹ�Ŵ��㷨(����ֵ���䡢ƽ��ֵ���䡢���������¸���)
        break
    end
end
            

   
end