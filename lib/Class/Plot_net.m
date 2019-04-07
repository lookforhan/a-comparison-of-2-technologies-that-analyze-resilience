classdef Plot_net < handle
    %Plot_net ���ƹ�ˮ����ʾ��ͼ
    %   ���Է���������ߵ���ɫ�����͡�
    
    properties
        net_data % ��������
    end
    properties
        line_control_id %��Ӧ�ߵ�id
        line_control_status % ��ʾ�Ͽ���1��ʾй¶��0��ʾ���
        node_control_id %��Ӧ�ڵ��id
        node_control_status %
    end
    properties % �ߵľ��
        Line
    end
    
    methods
        function obj = Plot_net(Net_data)
            obj.net_data = Net_data;
        end
    end
    methods % ����
        function Plot_basic(obj)
            pipe_line=obj.net_data{5,2}(:,1:3);
%             D=cell2mat(obj.net_data{5,2}(:,5));
            node_coodinate=obj.net_data{23,2};
            sum_pipe_num=numel(pipe_line(:,1));
            node_x=cell2mat(node_coodinate(:,2));
            node_y=cell2mat(node_coodinate(:,3));
            figure
            scatter(node_x,node_y,'k','filled')%�����ڵ�
            for i=1:sum_pipe_num
                node1_index=ismember(node_coodinate(:,1),pipe_line{i,2});
                node2_index=ismember(node_coodinate(:,1),pipe_line{i,3});
                temp_x1=node_x(node1_index);
                temp_y1=node_y(node1_index);
                temp_x2=node_x(node2_index);
                temp_y2=node_y(node2_index);
%                 obj.lineHandle(i)=line([temp_x1,temp_x2],[temp_y1,temp_y2]);
                obj.Line(i).Handle=line([temp_x1,temp_x2],[temp_y1,temp_y2]);
                hold on
            end
        end
        function Setline(obj,i,color) %��������ɫ
            set(obj.Line(i).Handle,'color',color);
        end
    end
end

