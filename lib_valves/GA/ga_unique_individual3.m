function [ pop_uniq,pop_uniq_not,new_individual_record_mat ] = ga_unique_individual3( pop_init,individual_record_mat )
%ga_unique_individual �жϸ����Ƿ񾭹�ģ��
%   ���룺pop_init��������Ⱥ����
%   ���룺individual_recordģ���¼�ĸ���ľ�����
%   �����pop_uniq��δ����¼�ĸ���
%   �����new_individual_record_mat��¼�ĸ���ľ�����
%   �����uniq_loc_in_pop_��¼���ظ�����pop_uniq1�е�λ��
%   �����not_uniq_loc_in_pop��¼�ظ�������pop_init�е�λ��
%   �����not_uniq_locin_record��¼�ظ�������individual_record�е�λ��
%   �����uniq1_loc_in_init��¼pop_uniq_1������pop_init�е�λ��

individual_mat = pop_init;

[lia1,~] = ismember(individual_mat,individual_record_mat,'rows');
pop_uniq = individual_mat(~lia1,:);% �����ɵĸ���
pop_uniq_not = individual_mat(lia1,:);% �Ѿ���¼�ĸ���
new_individual_record_mat = [individual_record_mat;pop_init];
end

