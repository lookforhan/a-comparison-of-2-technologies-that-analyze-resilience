function [ pop_uniq,new_individual_record_mat,uniq_loc_in_pop,not_uniq_loc_in_pop,not_uniq_loc_in_record,uniq1_loc_in_init ] = ga_unique_individual2( pop_init,individual_record_mat )
%ga_unique_individual �жϸ����Ƿ񾭹�ģ��
%   ���룺pop_init��������Ⱥ����
%   ���룺individual_recordģ���¼�ĸ���ľ�����
%   �����pop_uniq��δ����¼�ĸ���
%   �����new_individual_record_mat��¼�ĸ���ľ�����
%   �����uniq_loc_in_pop_��¼���ظ�����pop_uniq1�е�λ��
%   �����not_uniq_loc_in_pop��¼�ظ�������pop_init�е�λ��
%   �����not_uniq_locin_record��¼�ظ�������individual_record�е�λ��
%   �����uniq1_loc_in_init��¼pop_uniq_1������pop_init�е�λ��
pop_init_size = numel(pop_init);
individual_mat = [];
for i = 1:pop_init_size
    individual_mat = [individual_mat,cell2mat(pop_init{i})];
end
[individual_mat_tran,ia1,ic1] = unique(individual_mat','rows');
uniq1_loc_in_init=ic1;
pop_uniq_1=pop_init(ia1);%�����ڲ����ظ�
loc_id = (1:numel(pop_uniq_1))';
[lia1,lib1] = ismember(individual_mat_tran,individual_record_mat,'rows');
pop_uniq = pop_uniq_1(~lia1);% �����ɵĸ���
pop_uniq_not = pop_uniq_1(lia1);% �Ѿ���¼�ĸ���
individual_mat_tran_uniq = individual_mat_tran(~lia1,:);
loc_id_uniq = loc_id(~lia1);
uniq_loc_in_pop = loc_id_uniq ;
individual_mat_tran_uniq_not = individual_mat_tran(lia1,:);
lic_id_uniq_not = loc_id(lia1);
not_uniq_loc_in_pop=lic_id_uniq_not;
[lia2,lib2] = ismember(individual_mat_tran_uniq_not,individual_record_mat,'rows');
not_uniq_loc_in_record = lib2;
new_individual_record_mat = [individual_record_mat;individual_mat_tran_uniq];
end

