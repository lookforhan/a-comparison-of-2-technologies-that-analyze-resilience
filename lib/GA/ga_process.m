function [ newPop ] = ga_process( pop,fit,pm,pc )
%ga_process �Ŵ��㷨����
%   ���룺popԭ��Ⱥ
%   ���룺fitԭ��Ⱥ��Ӧ��
%   ���룺pm�������
%   ���룺pc�������
%   ���������Ⱥ
%   ������ѡ�񡢽��桢���졢��Ӣ����
Fitvalue=linear_normalized(fit,100,2.5);%��һ��
 [newpop_section,best_indiv]=selection2(pop,Fitvalue);%% ѡ��
 [newpop_cross,record_cross]=crossover5(newpop_section,pc);%����
 [newpop_mutation,record_mutation]=mutation2(newpop_cross,pm);%����
 newPop = [newpop_mutation;best_indiv;best_indiv];
end

