classdef cal_resilience_index < handle
    %cal_resilience_index 本类是为了计算供水管网震后韧性RI
    %   输入data,为供水管网每个时刻的（系统/节点）供水满足率
    %   resilience_index_mean_serviceability为整个修复过程的平均供水满足率
    %   resilience_index_mean_recovery_rate为修复过程中，供水满足率达到index指标的平均相对速率，需要输入index值（0~1）
    %   平均相对速率，供水满足了率恢复至index的时间为这段时间（x2-x1）/(全部修复时间)
    properties
        data
        index
    end
    properties(Dependent)
        resilience_index_mean_serviceability
        resilience_index_mean_recovery_rate
    end
    
    methods
        function obj = cal_resilience_index(data)
            obj.data = data;
        end
        function resilience_index_mean_serviceability = get.resilience_index_mean_serviceability(obj)
            resilience_index_mean_serviceability = sum(obj.data)/numel(obj.data);
        end
        function resilience_index_mean_recovery_rate = get.resilience_index_mean_recovery_rate(obj)
            y1 = min(obj.data);
            x1 = find(obj.data==y1, 1, 'last' );
            x2 = find(obj.data >=obj.index,1,'first');
            y2 = obj.data(x2);
            resilience_index_mean_recovery_rate = (numel(obj.data)-1)*(y2-y1)/(x2-x1);%相对斜率
        end
    end
    
end

