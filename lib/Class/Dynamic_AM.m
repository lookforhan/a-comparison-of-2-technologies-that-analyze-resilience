classdef Dynamic_AM < handle
    %Dynamic_AM  Dynamic_Adjacency Matrix
    %   ��̬��¼�޸������й����ڽӾ���
    %   ����޸������еĹ����ڵ�    
    properties
        adj_mat % �ڽӾ���
        
    end
    properties % input
        pipe_status % �ܵ�״̬
        net_data % ��ʼ��������
    end
    properties
        init_adj_mat % ��ʼ�����ڽӾ���
        damage_net_adj_mat % �ƻ�������ڽӾ���
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

