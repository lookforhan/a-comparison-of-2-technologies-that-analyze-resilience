classdef greedy_pipe_isolation_priority < handle
    %greedy_pipe_priority 采用贪婪算法来确定破坏管道的修复次序    
    %   1.确定隔离次序方法     
    properties
        lib_name = 'EPANETx64PDD' % 计算所用动态链接库名称
    end
    properties % 输入参数
        net_data % 管网信息
        damage_pipe_info % 破坏管道信息
        isolation_time % 需要隔离的管道的隔离时间
        inp_file % 破坏管网inp文件
        pipe_relative % 管道与新加管道关系
    end
    properties(Dependent)
        n_break_pipe
        break_pipe_id:
    end
    methods
        function obj = greedy_pipe_isolation_priority(inp_file,net_data,damage_pipe_info,isolation_time_mat，pipe_relative)
            obj.inp_file = inp_file;
            obj.net_data = net_data;
            obj.damage_pipe_info = damage_pipe_info;
            obj.isolation_time = isolation_time_mat;
            obj.pipe_relative = pipe_relative;
            if libisloaded(obj.lib_name)
                disp([obj.lib_name,'is loaded.'])
            else
                disp([obj.lib_name,'is NOT loaded!!'])
            end
        end
        function Run(obj)
        end
    end
    methods % get
        function n_break_pipe = get.n_break_pipe(obj)
            n_break_pipe = sum(obj.damage_pipe_info{3}==2);
        end
        function break_pipe_id = get.break_pipe_id(obj)
            break_pipe_id = obj.damage_pipe_info{5}(obj.damage_pipe_info{3}==2,1);
        end
    end
end

