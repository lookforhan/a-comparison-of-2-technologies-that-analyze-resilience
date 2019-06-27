function [outputArg1] = calculate_SSI(inputArg1,inputArg2)
%calculate_SSI ���㹩ˮ����ϵͳ��ˮ������
%   [outputArg1] = calculate_SSI([1.5;1.4],[2;2])
%   outputArg1 = 0.725;
%   [outputArg1] = calculate_SSI([-1.5;1.4],[2;2])
%   outputArg1 = 0.3500;
%   [outputArg1] = calculate_SSI([1.5;2.4],[2;2])
%   outputArg1 = 0.3750;
cal_demand_chosen_node = inputArg1;
req_demand_chosen_node = inputArg2;
new_cal_demand_chosen_node = cal_demand_chosen_node;%����������Ҫ���쳣�Ľڵ���ˮ�����е���
new_cal_demand_chosen_node(cal_demand_chosen_node<0) = 0; %������ˮ��Ϊ��ֵʱ��������ˮ������Ϊ0��
new_cal_demand_chosen_node(cal_demand_chosen_node>req_demand_chosen_node) = 0;%��������ˮ��������ˮ���������Ϊ0��
output_system_serviceability = sum(new_cal_demand_chosen_node)/sum(req_demand_chosen_node);
outputArg1 = output_system_serviceability;
end

