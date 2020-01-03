function [ pop_uniq,pop_uniq_not,new_individual_record_mat ] = ga_unique_individual3( pop_init,individual_record_mat )
%ga_unique_individual 判断个体是否经过模拟
%   输入：pop_init待检查的种群个体
%   输入：individual_record模拟记录的个体的矩阵表达
%   输出：pop_uniq，未被记录的个体
%   输出：new_individual_record_mat记录的个体的矩阵表达
%   输出：uniq_loc_in_pop_记录独特个体在pop_uniq1中的位置
%   输出：not_uniq_loc_in_pop记录重复个体在pop_init中的位置
%   输出：not_uniq_locin_record记录重复个体在individual_record中的位置
%   输出：uniq1_loc_in_init记录pop_uniq_1个体在pop_init中的位置

individual_mat = pop_init;

[lia1,~] = ismember(individual_mat,individual_record_mat,'rows');
pop_uniq = individual_mat(~lia1,:);% 新生成的个体
pop_uniq_not = individual_mat(lia1,:);% 已经记录的个体
new_individual_record_mat = [individual_record_mat;pop_init];
end

