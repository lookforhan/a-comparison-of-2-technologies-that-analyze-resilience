classdef PipeSort < handle
    %PipeSort ��ָ���ܵ������������
    %   �˴���ʾ��ϸ˵��
    %   a = PipeSort(net_data,{'1';'2';'3'})
    properties
        diameter
        ID
        chosenPipeID
        net_data
        sortPipeID
        sortPipeDiameter
        sortPipeLocb
    end
    
    methods
        function obj = PipeSort(net_data,pipeID)
            obj.diameter = net_data{5,2}(:,5);
            obj.ID = net_data{5,2}(:,1);
            obj.net_data = net_data;
            obj.chosenPipeID = pipeID;
        end
        function SortGraphDistance(obj,damage_pipe_info)
            % LADWP�����в��õ��޸��ܵ��ƻ����ȴ��򷽷���
            % ���룬
            % damage_pipe_info �ƻ��ܵ��ƻ���Ϣ
            % net_data. ������Ϣ
            % damage_pipe_info{1}%�ܵ�����
            % damage_pipe_info{2}%�ƻ���λ��
            % damage_pipe_info{3}%�ƻ�����
            % damage_pipe_info{4}%й¶ϵ��
            % �����޸���ˮ��·��ֱ������610mm����Ҫ�ܵ�ֱ��net_data{5,2}(:,5)��
            % �ȶϿ�������©��(��Ҫ�ƻ�����damage_pipe_info{3})
            % ��ˮ�����ȶϿ�������©��(��Ҫ�ƻ�����damage_pipe_info{3})
            net_data_1 = obj.net_data;
            breakpipe=damage_pipe_info{1};
            % first �ҵ��ƻ��ܵ��еĸ�·
            D=cell2mat(net_data_1{5,2}(:,5));%ֱ��
            D_damage=D(damage_pipe_info{1});%�ƻ��ܵ���ֱ��
            index_trunk=breakpipe(D_damage>=610);
            index_distribution=breakpipe(D_damage<610);
            % scend �ҵ��Ͽ���й¶�ƻ�
            % 2.1��·�Ͽ���й¶
            [~,index_trunk_Indamage]=ismember(index_trunk,damage_pipe_info{1});
            index_trunk_break=index_trunk(damage_pipe_info{3}(index_trunk_Indamage,1)==2);
            index_trunk_leak=index_trunk(damage_pipe_info{3}(index_trunk_Indamage,1)==1);
            % 2.2֧·�Ͽ���й¶
            [~,index_distribution_Indamage]=ismember(index_distribution,damage_pipe_info{1});
            index_distribution_break=index_distribution(damage_pipe_info{3}(index_distribution_Indamage,1)==2);
            index_distribution_leak=index_distribution(damage_pipe_info{3}(index_distribution_Indamage,1)==1);
            % third ����ˮԴ�ľ���
            mid = pipeShortest2Reservoirs(net_data_1);
            if ~isempty(index_trunk)
                
                mid.chosenPipeID = net_data_1{5,2}(index_trunk_break,1);
                index1 = mid.shortest_path_dist;
                index_trunk_break_1 = [index_trunk_break_,index1];
                index_trunk_break_2 = sortrows(index_trunk_break_1,2);
                index_trunk_break_final=index_trunk_break_2(:,1);
                
                
                mid.chosenPipeID = net_data_1{5,2}(index_trunk_leak,1);
                index1 = mid.shortest_path_dist;
                index_trunk_leak_1 = [index_trunk_leak,index1];
                index_trunk_leak_2 = sortrows(index_trunk_leak_1,2);
                index_trunk_leak_final=index_trunk_leak_2(:,1);
            else
                index_trunk_break_final =[];
                index_trunk_leak_final =[];
            end
            mid.chosenPipeID = net_data_1{5,2}(index_distribution_break,1);
            index1 = mid.shortest_path_dist;
            index_distribution_break_1 = [index_distribution_break,index1];
            index_distribution_break_2 = sortrows(index_distribution_break_1,2);
            index_distribution_break_final=index_distribution_break_2(:,1);
            
            mid.chosenPipeID = net_data_1{5,2}(index_distribution_leak,1);
            index1 = mid.shortest_path_dist;
            index_distribution_leak_1 = [index_distribution_leak,index1];
            index_distribution_leak_2 = sortrows(index_distribution_leak_1,2);
            index_distribution_leak_final=index_distribution_leak_2(:,1);
            
            mid.delete
            
            obj.sortPipeLocb=[index_trunk_break_final;index_trunk_leak_final;index_distribution_break_final;index_distribution_leak_final];
        end
        function SortStraightLineDistance2Reservoirs(obj)
            % ����ܵ���ˮԴ���ֱ�߾����С��������
            theChosenPipe = obj.chosenPipeID;
            coordinate = obj.net_data{23,2};%�ڵ�����
            pipe_info = obj.net_data{5,2};%�ܵ���ڵ��ϵ
            [~,pipe_index] = ismember(theChosenPipe,pipe_info(:,1));
            n_pipe = numel(theChosenPipe);
            StraightLineDistance = zeros(n_pipe,1);
            reservoirs_id = obj.net_data{3,2}(:,1);
            [~,reservoirs_index] = ismember(reservoirs_id,coordinate(:,1));
            reservoirs_coordinate = cell2mat(coordinate(reservoirs_index,2:3));
            middle_distance = zeros(numel(reservoirs_id),1);
            for i = 1:n_pipe
                N1 = pipe_info(pipe_index(i),2);
                N2 = pipe_info(pipe_index(i),3);
                [~,N1_index] = ismember(N1,coordinate(:,1));
                [~,N2_index] = ismember(N2,coordinate(:,1));
                N1_x = coordinate{N1_index,2};
                N1_y = coordinate{N1_index,3};
                N2_x = coordinate{N2_index,2};
                N2_y = coordinate{N2_index,3};
                pipe_x = (N1_x+N2_x)/2;
                pipe_y = (N1_y+N2_y)/2; 
                for j = 1:numel(reservoirs_id)
                    middle_distance(j) = sqrt((pipe_x-reservoirs_coordinate(j,1))^2+(pipe_y-reservoirs_coordinate(j,2))^2);
                end
                StraightLineDistance(i) = min(middle_distance);
            end 
            [~,theLoc] = ismember(theChosenPipe,obj.ID);
            theData = [theChosenPipe,num2cell(StraightLineDistance),num2cell(theLoc)];
            theNewData = sortrows(theData,2);
            obj.sortPipeID = theNewData (:,1);
            obj.sortPipeLocb = theNewData(:,3);
        end
        function SortDiameter_high2low(obj)
            theChosenPipe = obj.chosenPipeID;
            [~,theLoc] = ismember(theChosenPipe,obj.ID);
            theChosenPipeDiameter = obj.diameter(theLoc);
            theData = [theChosenPipe,theChosenPipeDiameter,num2cell(theLoc)];
            theNewData = sortrows(theData,2);
            obj.sortPipeDiameter = flipud(theNewData (:,2));
            obj.sortPipeID = flipud(theNewData (:,1));
            obj.sortPipeLocb = flipud(theNewData(:,3));
        end
        function SortDiameter_low2high(obj)
            theChosenPipe = obj.chosenPipeID;
            [~,theLoc] = ismember(theChosenPipe,obj.ID);
            theChosenPipeDiameter = obj.diameter(theLoc);
            theData = [theChosenPipe,theChosenPipeDiameter,num2cell(theLoc)];
            theNewData = sortrows(theData,2);
            obj.sortPipeDiameter = theNewData (:,2);
            obj.sortPipeID = theNewData (:,1);
            obj.sortPipeLocb = theNewData(:,3);
        end
        function SortIndex_high2low(obj,theChosenIndex)
            theChosenPipe = obj.chosenPipeID;
            [~,theLoc] = ismember(theChosenPipe,obj.ID);
            theData = [theChosenPipe,theChosenIndex,num2cell(theLoc)];
            theNewData = sortrows(theData,2);
            obj.sortPipeDiameter = flipud(theNewData (:,2));
            obj.sortPipeID = flipud(theNewData (:,1));
            obj.sortPipeLocb = flipud(theNewData(:,3));
        end
        function sortIndex_low2high(obj,theChosenIndex)
            theChosenPipe = obj.chosenPipeID;
            [~,theLoc] = ismember(theChosenPipe,obj.ID);
            theData = [theChosenPipe,theChosenIndex,num2cell(theLoc)];
            theNewData = sortrows(theData,2);
            obj.sortPipeDiameter = theNewData (:,2);
            obj.sortPipeID = theNewData (:,1);
            obj.sortPipeLocb = theNewData(:,3);
        end
        function SortNothing(obj)
            theChosenPipe = obj.chosenPipeID;
            [~,theLoc] = ismember(theChosenPipe,obj.ID);
            theChosenPipeDiameter = obj.diameter(theLoc);
            theData = [theChosenPipe,theChosenPipeDiameter,num2cell(theLoc)];
            theNewData = theData;
            obj.sortPipeDiameter = theNewData (:,2);
            obj.sortPipeID = theNewData (:,1);
            obj.sortPipeLocb = theNewData(:,3);
        end
    end
    
end

