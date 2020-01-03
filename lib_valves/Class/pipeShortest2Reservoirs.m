classdef pipeShortest2Reservoirs < handle
    %pipeShortest2Reservoirs 计算管道到源点的最短距离
    %   调用graphshortestpath函数实现
    
    properties
        net_data
        virtual_reserviors
        chosenPipeID
        
    end
    properties(Dependent)
       weight
       graph
       graph_weight
       shortest_path_dist
       all_node_id
    end
    methods
        function obj = pipeShortest2Reservoirs(net_data)
            obj.net_data = net_data;  
        end

        function graph = get.graph(obj)
            pipe_n1_id = obj.net_data{5,2}(:,2);
            pipe_n2_id = obj.net_data{5,2}(:,3);
            
            reservoris_id = obj.net_data{3,2}(:,1);
            virtual_reservoris_id = {'v-1'};
            
            virtual_pipe_num = numel(reservoris_id);
            all_pipe_n1_id = [pipe_n1_id;reservoris_id(1:3);virtual_reservoris_id];
            all_pipe_n2_id = [pipe_n2_id;repmat(virtual_reservoris_id,virtual_pipe_num-1,1);reservoris_id(4)];
            [~,all_n1] = ismember(all_pipe_n1_id,obj.all_node_id);
            [~,all_n2] = ismember(all_pipe_n2_id,obj.all_node_id);
            [~,obj.virtual_reserviors] = ismember(virtual_reservoris_id,obj.all_node_id);
            graph = [all_n1,all_n2];
        end
        function weight = get.weight(obj)
            pipe_length = cell2mat(obj.net_data{5,2}(:,4));
            reservoris_id = obj.net_data{3,2}(:,1);
            virtual_pipe_num = numel(reservoris_id);
            virtual_pipe_length = ones(virtual_pipe_num,1)*0.001;
            weight = [pipe_length;virtual_pipe_length];
        end
        function graph_weight = get.graph_weight(obj)
            l1 =obj.graph(:,1)';
            l2 =obj.graph(:,2)';
            l3 =obj.weight';
            graph_weight = sparse(l1,l2,l3);
        end
        function all_node_id = get.all_node_id(obj)
            node_id = obj.net_data{23,2}(:,1);
            virtual_reservoris_id = {'v-1'};
            all_node_id = [node_id;virtual_reservoris_id];
        end
        function shortest_path_dist = get.shortest_path_dist(obj)
            thosen_pipe_num = numel(obj.chosenPipeID);
            pipe_id = obj.net_data{5,2}(:,1);
            shortest_path_dist = zeros(thosen_pipe_num,1);
            for i = 1:thosen_pipe_num
                pipe_i_id = obj.chosenPipeID(i);
                [~,pipe_i_loc] = ismember(pipe_i_id,pipe_id);
                pipe_i_n1 = obj.net_data{5,2}(pipe_i_loc,2);
                pipe_i_n2 = obj.net_data{5,2}(pipe_i_loc,3);
                [~,pipe_i_n1_loc] = ismember(pipe_i_n1 ,obj.all_node_id);
                [~,pipe_i_n2_loc] = ismember(pipe_i_n2 ,obj.all_node_id);
                UG = tril(obj.graph_weight +obj.graph_weight');
                [dist(1),~,~] = graphshortestpath(UG,pipe_i_n1_loc,obj.virtual_reserviors,'directed',false);
                [dist(2),~,~] = graphshortestpath(UG,pipe_i_n2_loc,obj.virtual_reserviors,'directed',false);
                shortest_path_dist(i) = mean(dist);
            end
        end
    end
    
end

