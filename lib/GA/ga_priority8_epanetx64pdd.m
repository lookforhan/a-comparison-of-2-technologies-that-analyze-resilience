% �½�һ����������¼ģ����ĸ��壬���Ƚ�
% ������epanetx64pdd.dllʱ����д���Ŵ������̡���ga_priority6.m�Ļ������޸ġ�
function [pop_isolation_record,Fit_record]...
    =ga_priority8_epanetx64pdd(popsize,generation_length,pc,pm,...��Ⱥ��С������������������ʣ��������
    out_dir,....���Ŀ¼
    RepairCrew,...�޸����飬
    damage_pipe_info,net_data,pipe_relative,...�ƻ���Ϣ��������Ϣ���ƻ��ܵ�����½��ܵ�
    EPA_format,...node_original_data,system_original_L,...EPA��ʽ���ڵ�ԭ�����ݣ�ϵͳԭ���ܵ�����
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...���ʱ�䣬�޸�ʱ�䣬�ƶ�ʱ��
    crewStartTime,crewEfficiencyRecovery,crewEfficiencyIsolation,crewEfficiencyTravel,...
    output_net_filename_inp)%,...
% ����
DamagePipe_order = damage_pipe_info{1};%��Ҫ�޸��Ĺܵ�
BreakPipe_order = damage_pipe_info{1}(damage_pipe_info{3}==2);%��Ҫ����Ĺܵ�
%
[pop_isolation_init,pop_replacement_init]=initpop3(popsize,BreakPipe_order,DamagePipe_order);
%%%%% �жϳ�ʼ��Ⱥ���Ƿ�����ظ�����

[c_isolationBreak,ia_isolationBreak,ic_isolationBreak] = unique(pop_isolation_init,'rows');%����������и����Ƿ�����ظ�
[c_replacement,ia_replacement,ic_replacement] = unique(pop_replacement_init,'rows');%����޸������и����Ƿ�����ظ�
pop_isolation_uniq = c_isolationBreak;
pop_isolation_record = pop_isolation_uniq;%��¼����

Fit_max = zeros(generation_length,1);
Fit_mean = zeros(generation_length,1);
for generation_i = 1:generation_length
    generation_dir_i=[out_dir,'�Ŵ���',num2str(generation_i),'��\'];
    mkdir(generation_dir_i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ�����i��
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
        disp(['��ֵ���Ϊ',num2str(error)])
        disp(['�Ŵ�����Ϊ',num2str(generation_i)])
        break
    end
    end
end
if generation_i==generation_length
    disp(['�Ŵ�����Ϊ',num2str(generation_i)])
    break
end
% % ga ����
[ newPop_isolation ] = ga_process( pop_isolation_init,Fit_init,pm,pc );
[ pop_uniq,pop_uniq_not,new_individual_record_mat ] = ga_unique_individual3( newPop_isolation,pop_isolation_record );
[lia1,locb1] = ismember(pop_uniq,newPop_isolation,'rows')
[lia2,locb2] = ismember(pop_uniq_not,newPop_isolation,'rows')
[lia3,locb3] = ismember(pop_uniq_not,pop_isolation_record,'rows')
pop_isolation_uniq = pop_uniq;
pop_isolation_record=new_individual_record_mat;



if isempty(pop_uniq)
    disp('û�в����¸���')
    disp(['�Ŵ�����Ϊ',num2str(generation_i)])
    break
end

end
            

   
end