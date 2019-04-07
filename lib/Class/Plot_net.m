classdef Plot_net < handle
    %Plot_net 绘制供水管网示意图
    %   可以方便的设置线的颜色和类型。
    
    properties
        net_data % 管网数据
    end
    properties
        line_control_id %对应线的id
        line_control_status % 表示断开，1表示泄露，0表示完好
        node_control_id %对应节点的id
        node_control_status %
    end
    properties % 线的句柄
        Line
    end
    
    methods
        function obj = Plot_net(Net_data)
            obj.net_data = Net_data;
        end
    end
    methods % 功能
        function Plot_basic(obj)
            pipe_line=obj.net_data{5,2}(:,1:3);
%             D=cell2mat(obj.net_data{5,2}(:,5));
            node_coodinate=obj.net_data{23,2};
            sum_pipe_num=numel(pipe_line(:,1));
            node_x=cell2mat(node_coodinate(:,2));
            node_y=cell2mat(node_coodinate(:,3));
            figure
            scatter(node_x,node_y,'k','filled')%画出节点
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
        function Setline(obj,i,color) %设置线颜色
            set(obj.Line(i).Handle,'color',color);
        end
    end
end

