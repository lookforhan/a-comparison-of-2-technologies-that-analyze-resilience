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
    properties % 2D句柄
        Fig_basic
        Line
        Node
    end
    properties % 3D句柄
        Fig_3d_elev
        Fig_3d_junction
        Line_3d
        Node_3d
        Junction_attribute
    end
    methods
        function obj = Plot_net(Net_data)
            obj.net_data = Net_data;
        end
    end
    methods % 2D功能
        function Plot_basic(obj)
            pipe_line=obj.net_data{5,2}(:,1:3);
            %             D=cell2mat(obj.net_data{5,2}(:,5));
            node_coodinate=obj.net_data{23,2};
            sum_pipe_num=numel(pipe_line(:,1));
            node_x=cell2mat(node_coodinate(:,2));
            node_y=cell2mat(node_coodinate(:,3));
            node_z = zeros (numel(node_coodinate(:,2)),1);
            reservoirs_id = obj.net_data{3,2}(:,1);
            junction_id = obj.net_data{2,2}(:,1);
            node_id = node_coodinate(:,1);
            obj.Fig_basic = figure;
            node_type = zeros (numel(node_coodinate(:,2)),1);
            hold on
            %             obj.Node = scatter(node_x,node_y,'k','filled');%画出节点
            for node_i = 1:numel(node_coodinate(:,2))
                [node_lia1,~] = ismember(node_id(node_i),junction_id);
                if node_lia1
                    node_z(node_i) = 0;
                    node_type(node_i) = 0;%普通节点
                    obj.Node(node_i).Handle = scatter3(node_x(node_i),node_y(node_i),node_z(node_i),10,'k','filled');
                else
                    [node_lia2,~] = ismember(node_id(node_i),reservoirs_id);
                    if node_lia2
                        node_type(node_i) = 1;%水源
                        node_z(node_i) = 0;
                        obj.Node(node_i).Handle = scatter3(node_x(node_i),node_y(node_i),node_z(node_i),15,'d','r','filled');
                    else
                    end
                end
            end
            for i=1:sum_pipe_num
                node1_index=ismember(node_coodinate(:,1),pipe_line{i,2});
                node2_index=ismember(node_coodinate(:,1),pipe_line{i,3});
                temp_x1=node_x(node1_index);
                temp_y1=node_y(node1_index);
                temp_x2=node_x(node2_index);
                temp_y2=node_y(node2_index);
                %                 obj.lineHandle(i)=line([temp_x1,temp_x2],[temp_y1,temp_y2]);
                obj.Line(i).Handle=line([temp_x1,temp_x2],[temp_y1,temp_y2]);
            end
        end
    end
    methods % 3D功能
        function Plot_3d_elevation(obj) %
            if ~isempty(obj.net_data{4,2})
                disp('2019-4-9:本功能暂不支持带水池(TANK)的管网!')
                return
            end
            obj.Fig_3d_elev = figure;
            hold on
            pipe_line = obj.net_data{5,2}(:,1:3);
            node_coodinate=obj.net_data{23,2};
            junction_elev = cell2mat(obj.net_data{2,2}(:,2));
           
            reservoirs_head = cell2mat(obj.net_data{3,2}(:,2));
             reservoirs_id = obj.net_data{3,2}(:,1);
            junction_id = obj.net_data{2,2}(:,1);
            node_id = node_coodinate(:,1);
            node_x = cell2mat(node_coodinate(:,2));
            node_y=cell2mat(node_coodinate(:,3));
            node_z = zeros (numel(node_coodinate(:,2)),1);
            node_type = zeros (numel(node_coodinate(:,2)),1);
            % plot scatter3
            for node_i = 1:numel(node_coodinate(:,2))
                [node_lia1,node_index1] = ismember(node_id(node_i),junction_id);
                if node_lia1
                    node_z(node_i) = junction_elev(node_index1);
                    node_type(node_i) = 0;%普通节点
                    obj.Node_3d(node_i).Handle = scatter3(node_x(node_i),node_y(node_i),node_z(node_i),'k','filled');
                else
                    [node_lia2,node_index2] = ismember(node_id(node_i),reservoirs_id);
                    if node_lia2
                        node_type(node_i) = 1;%水源
                        node_z(node_i) = reservoirs_head(node_index2);
                        obj.Node_3d(node_i).Handle = scatter3(node_x(node_i),node_y(node_i),node_z(node_i),40,'d','r','filled');
                    else
                    end
                end
            end
            for pipe_i = 1:numel(pipe_line(:,1))
                node1_index=ismember(node_coodinate(:,1),pipe_line{pipe_i,2});
                node2_index=ismember(node_coodinate(:,1),pipe_line{pipe_i,3});
                temp_x1=node_x(node1_index);
                temp_y1=node_y(node1_index);
                temp_z1=node_z(node1_index);
                temp_x2=node_x(node2_index);
                temp_y2=node_y(node2_index);
                temp_z2=node_z(node2_index);
                %                 obj.lineHandle(i)=line([temp_x1,temp_x2],[temp_y1,temp_y2]);
                obj.Line(pipe_i).Handle=line([temp_x1,temp_x2],[temp_y1,temp_y2],[temp_z1,temp_z2]);
            end
        end
        function Plot_3d_junction(obj,junction_id,junction_attribute)
            if ~isempty(obj.net_data{4,2})
                disp('2019-4-9:本功能暂不支持带水池(TANK)的管网!')
                return
            end
            obj.Fig_3d_junction = figure;
            hold on
            pipe_line=obj.net_data{5,2}(:,1:3);
            node_coodinate=obj.net_data{23,2};
            reservoirs_id = obj.net_data{3,2}(:,1);
            junction_all_id = obj.net_data{2,2}(:,1);
            node_id = node_coodinate(:,1);
            node_x=cell2mat(node_coodinate(:,2));
            node_y=cell2mat(node_coodinate(:,3));
            node_z = zeros (numel(node_coodinate(:,2)),1);
            node_type = zeros (numel(node_coodinate(:,2)),1);
            % plot scatter3
            for node_i = 1:numel(node_coodinate(:,2))
                [node_lia1,~] = ismember(node_id(node_i),junction_all_id);
                if node_lia1
                    node_z(node_i) = 0;
                    node_type(node_i) = 0;%普通节点
                    obj.Node_3d(node_i).Handle = scatter3(node_x(node_i),node_y(node_i),node_z(node_i),'k','filled');
                else
                    [node_lia2,~] = ismember(node_id(node_i),reservoirs_id);
                    if node_lia2
                        node_type(node_i) = 1;%水源
                        node_z(node_i) = 0;
                        obj.Node_3d(node_i).Handle = scatter3(node_x(node_i),node_y(node_i),node_z(node_i),40,'d','r','filled');
                    else
                    end
                end
            end
            % plot line
            for pipe_i = 1:numel(pipe_line(:,1))
                node1_index=ismember(node_coodinate(:,1),pipe_line{pipe_i,2});
                node2_index=ismember(node_coodinate(:,1),pipe_line{pipe_i,3});
                temp_x1=node_x(node1_index);
                temp_y1=node_y(node1_index);
                temp_z1=node_z(node1_index);
                temp_x2=node_x(node2_index);
                temp_y2=node_y(node2_index);
                temp_z2=node_z(node2_index);
                %                 obj.lineHandle(i)=line([temp_x1,temp_x2],[temp_y1,temp_y2]);
                obj.Line(pipe_i).Handle=line([temp_x1,temp_x2],[temp_y1,temp_y2],[temp_z1,temp_z2]);
            end
            % plot attribute
            for junction_i = 1:numel(junction_id)
                node_index_junction = ismember(node_coodinate(:,1),junction_id{junction_i});
                temp_j_x1 = node_x(node_index_junction);
                temp_j_y1 = node_y(node_index_junction);
                temp_j_z1 = 0;
                temp_j_x2 = temp_j_x1;
                temp_j_y2 = temp_j_y1;
                temp_j_z2 = temp_j_z1 + junction_attribute(junction_i);
                if junction_attribute(junction_i)<0
                    obj.Junction_attribute(junction_i).Handle = line([temp_j_x1,temp_j_x2],[temp_j_y1,temp_j_y2],[temp_j_z1,temp_j_z2],'Color','red'); 
                else
                    obj.Junction_attribute(junction_i).Handle = line([temp_j_x1,temp_j_x2],[temp_j_y1,temp_j_y2],[temp_j_z1,temp_j_z2],'Color','blue'); 
                end
                
            end
        end
    end
end

