classdef Dynamic_AM < handle
    %Dynamic_AM  Dynamic_Adjacency Matrix
    %   ��̬��¼�޸������й����ڽӾ���
    %   ����޸������еĹ����ڵ�    
    properties
        adj_mat % �ڽӾ���
        
    end
    properties % input
        
        net_data % ��ʼ��������
    end
    properties
        init_adj_mat % ��ʼ�����ڽӾ���
    end
    properties(Dependent,SetAccess = private) % �м����
        
        end_time % ʱ����е����ʱ��
        pipe_node % �ܵ���Ϣ���ڵ���ڵ�����ӹ�ϵ
        reservoir % ˮ��ı��
        all_node % ���нڵ�ı��
    end
    properties(SetAccess = private) % ���
        isol_node % isolated node �����ڵ�
    end
    methods
        function obj = Dynamic_AM(Net_data)
            obj.net_data = Net_data;
        end
        function Run(obj)
        end
    end
    methods
        function pipe_node = get.pipe_node(obj)
        end
    end
    
end

