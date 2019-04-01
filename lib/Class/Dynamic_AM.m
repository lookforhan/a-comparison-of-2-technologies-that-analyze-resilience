classdef Dynamic_AM < handle
    %Dynamic_AM  Dynamic_Adjacency Matrix
    %   动态记录修复过程中管网邻接矩阵
    %   检查修复过程中的孤立节点    
    properties
        adj_mat % 邻接矩阵
        
    end
    properties % input
        pipe_status % 管道状态
        net_data % 初始管网数据
    end
    properties
        init_adj_mat % 初始管网邻接矩阵
        damage_net_adj_mat % 破坏后管网邻接矩阵
    end
    properties(Dependent,SetAccess = private) % 中间变量
        
        end_time % 时间表中的最大时间
        pipe_node % 管道信息，节点与节点的连接关系
        reservoir % 水库的编号
        all_node % 所有节点的编号
    end
    properties(SetAccess = private) % 输出
        isol_node % isolated node 孤立节点
    end
    methods
        function obj = Dynamic_AM(Net_data,PipeStatus)
            obj.net_data = Net_data;
            obj.pipe_status = PipeStatus;
        end
        function Run(obj)
        end
    end
    methods
        function pipe_node = get.pipe_node(obj)
        end
    end
    
end

