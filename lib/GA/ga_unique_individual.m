function [ pop_uniq,new_individual_record_mat,uniq_loc_in_pop_logic,uniq_loc_in_pop,not_uniq_loc_in_pop,not_uniq_locin_record ] = ga_unique_individual( pop_init,individual_record_mat )
%ga_unique_individual �жϸ����Ƿ񾭹�ģ��
%   ���룺pop_init��������Ⱥ����
%   ���룺individual_recordģ���¼�ĸ���ľ�����
%   �����pop_uniq��δ����¼�ĸ���
%   �����new_individual_record_mat��¼�ĸ���ľ�����
%   �����uniq_loc_in_pop_logic��¼�ظ�������pop_init�е�λ��
%   �����uniq_loc_in_pop��¼���ظ�����pop_init�е�λ��
%   �����not_uniq_loc_in_pop��¼�ظ�������pop_init�е�λ��
%   �����not_uniq_locin_record��¼�ظ�������individual_record�е�λ��
pop_init_size = numel(pop_init);
individual_mat = [];
for i = 1:pop_init_size
    individual_mat = [individual_mat,cell2mat(pop_init{i})];
end
individual_mat_tran = unique(individual_mat','rows');
[lia1,lib1] = ismember(individual_mat_tran,individual_record_mat,'rows');
% [lia2,lib2] = ismember(individual_record_mat,individual_mat_tran,'rows');
uniq_loc_in_pop_logic = lia1;
pop_uniq=pop_init(~lia1);
individual_mat_tran_uniq = individual_mat_tran(~lia1,:);
individual_mat_tran_not_uniq = individual_mat_tran(lia1,:);
% [lia3,lib3] = ismember(individual_mat_tran,individual_mat_tran_uniq,'rows');
[lia4,lib4] = ismember(individual_mat_tran_uniq,individual_mat_tran,'rows');
[lia5,lib5] = ismember(individual_mat_tran_not_uniq,individual_mat_tran,'rows');
[lia6,lib6] = ismember(individual_mat_tran_not_uniq,individual_record_mat,'rows');
uniq_loc_in_pop = lib4;
not_uniq_loc_in_pop = lib5;
not_uniq_locin_record = lib6;
new_individual_record_mat = [individual_record_mat;individual_mat_tran(~lia1,:)];
end

