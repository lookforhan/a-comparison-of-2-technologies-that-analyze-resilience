classdef greedy_pipe_isolation_priority < handle
    %greedy_pipe_priority 采用贪婪算法来确定破坏管道的修复次序
    %   1.确定隔离次序方法
    properties
        lib_name = 'EPANETx64PDD' % 计算所用动态链接库名称
        errcode
    end
    properties % 输入参数
        net_data % 管网信息
        break_pipe_id % 破坏管道信息
        isolation_time % 需要隔离的管道的隔离时间
        inp_file % 破坏管网inp文件
        pipe_relative % 管道与新加管道关系
    end
    properties(Dependent) % 中间参数
        n_break_pipe % 破坏管道数量（隔离管道数量）
        current_system_serviceablity % 当前管网状态的系统供水满意率
        node_id % 管网所有用户节点id
        pipe_id % 管网所有管道id
        input_check % 检查输入参数是否匹配：1匹配；0不匹配，需要检查；
    end
    properties % 中间参数
    end
    properties % 输出参数
    end
    methods
        function obj = greedy_pipe_isolation_priority(inp_file,net_data,break_pipe_id,isolation_time_mat,pipe_relative)
            obj.inp_file = inp_file;
            obj.net_data = net_data;
            obj.break_pipe_id = break_pipe_id;
            obj.isolation_time = isolation_time_mat;
            obj.pipe_relative = pipe_relative;
            if libisloaded(obj.lib_name)
                disp([obj.lib_name,'is loaded.'])
            else
                disp([obj.lib_name,'is NOT loaded!!'])
            end
        end
        function Run(obj)
            for i = 1: obj.n_break_pipe
            end
        end
    end
    methods % get
        function n_break_pipe = get.n_break_pipe(obj)
            n_break_pipe = numel(obj.break_pipe_id);
        end
        function node_id = get.node_id(obj)
            node_id = obj.net_data{2,2}(:,1);
        end
        function input_check = get.input_check(obj)
            input_check.break_pipe_id_with_pipe_relative = all(ismember(obj.break_pipe_id,obj.pipe_relative(:,1)));
            input_check.pipe_relative_with_pipe_id = all(ismember(obj.pipe_relative(:,1),obj.pipe_id));
        end

        function pipe_id = get.pipe_id(obj)
            pipe_id = obj.net_data{5,2}(:,1);
        end

        function current_system_serviceablity = get.current_system_serviceablity(obj)
            obj.errcode.ENopen = calllib(obj.lib_name,'ENopen',obj.inp_file,[obj.inp_file(1:end-4),'current','.rpt'],'');
            obj.errcode.ENsettimeparam = calllib(obj.lib_name,'ENsettimeparam',0,0);% 设置模拟历时
            obj.errcode.ENsetoption = calllib(obj.lib_name,'ENsetoption',0,500);% 动态链接库中迭代次数
            obj.errcode.ENsloveH = calllib(obj.lib_name,'ENsolveH');
            [~,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
            current_system_serviceablity = sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
            obj.errcode.ENreport = calllib(obj.lib_name,'ENreport');
            obj.errcode.ENclose = calllib(obj.lib_name,'ENclose');
        end
    end
end

