function [outputArg1] = calculate_SSI(inputArg1,inputArg2)
%calculate_SSI 计算供水管网系统供水满足率
%   [outputArg1] = calculate_SSI([1.5;1.4],[2;2])
%   outputArg1 = 0.725;
%   [outputArg1] = calculate_SSI([-1.5;1.4],[2;2])
%   outputArg1 = 0.3500;
%   [outputArg1] = calculate_SSI([1.5;2.4],[2;2])
%   outputArg1 = 0.3750;
cal_demand_chosen_node = inputArg1;
req_demand_chosen_node = inputArg2;
new_cal_demand_chosen_node = cal_demand_chosen_node;%计算结果，需要将异常的节点需水量进行调整
new_cal_demand_chosen_node(cal_demand_chosen_node<0) = 0; %计算需水量为负值时，将其需水量调整为0；
new_cal_demand_chosen_node(cal_demand_chosen_node>req_demand_chosen_node) = 0;%若计算需水量大于需水量，则调整为0；
output_system_serviceability = sum(new_cal_demand_chosen_node)/sum(req_demand_chosen_node);
outputArg1 = output_system_serviceability;
end

