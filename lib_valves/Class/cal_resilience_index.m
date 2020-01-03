classdef cal_resilience_index < handle
    %cal_resilience_index ������Ϊ�˼��㹩ˮ�����������RI
    %   ����data,Ϊ��ˮ����ÿ��ʱ�̵ģ�ϵͳ/�ڵ㣩��ˮ������
    %   resilience_index_mean_serviceabilityΪ�����޸����̵�ƽ����ˮ������
    %   resilience_index_mean_recovery_rateΪ�޸������У���ˮ�����ʴﵽindexָ���ƽ��������ʣ���Ҫ����indexֵ��0~1��
    %   ƽ��������ʣ���ˮ�������ʻָ���index��ʱ��Ϊ���ʱ�䣨x2-x1��/(ȫ���޸�ʱ��)
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
            resilience_index_mean_recovery_rate = (numel(obj.data)-1)*(y2-y1)/(x2-x1);%���б��
        end
    end
    
end

