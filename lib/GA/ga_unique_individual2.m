function [ pop_uniq,new_individual_record_mat,uniq_loc_in_pop,not_uniq_loc_in_pop,not_uniq_loc_in_record,uniq1_loc_in_init ] = ga_unique_individual2( pop_init,individual_record_mat )
%ga_unique_individual 判断个体是否经过模拟
%   输入：pop_init待检查的种群个体
%   输入：individual_record模拟记录的个体的矩阵表达
%   输出：pop_uniq，未被记录的个体
%   输出：new_individual_record_mat记录的个体的矩阵表达
%   输出：uniq_loc_in_pop_记录独特个体在pop_uniq1中的位置
%   输出：not_uniq_loc_in_pop记录重复个体在pop_init中的位置
%   输出：not_uniq_locin_record记录重复个体在individual_record中的位置
%   输出：uniq1_loc_in_init记录pop_uniq_1个体在pop_init中的位置
pop_init_size = numel(pop_init);
individual_mat = [];
for i = 1:pop_init_size
    individual_mat = [individual_mat,cell2mat(pop_init{i})];
end
[individual_mat_tran,ia1,ic1] = unique(individual_mat','rows');
uniq1_loc_in_init=ic1;
pop_uniq_1=pop_init(ia1);%矩阵内部无重复
loc_id = (1:numel(pop_uniq_1))';
[lia1,lib1] = ismember(individual_mat_tran,individual_record_mat,'rows');
pop_uniq = pop_uniq_1(~lia1);% 新生成的个体
pop_uniq_not = pop_uniq_1(lia1);% 已经记录的个体
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

