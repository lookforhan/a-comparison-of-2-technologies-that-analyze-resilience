classdef PipeSort < handle
    %PipeSort 对指定管道进行排序的类
    %   此处显示详细说明
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
        function SortLosAngeles(obj,damage_pipe_info)
            % LADWP报告中采用的修复管道破坏优先次序方法。
            % 输入，
            % damage_pipe_info 破坏管道破坏信息
            % net_data. 管网信息
            % damage_pipe_info{1}%管道索引
            % damage_pipe_info{2}%破坏点位置
            % damage_pipe_info{3}%破坏类型
            % damage_pipe_info{4}%泄露系数
            % 优先修复输水干路：直径大于610mm（需要管道直径net_data{5,2}(:,5)）
            % 先断开，后渗漏。(需要破坏类型damage_pipe_info{3})
            % 配水管网先断开，后渗漏。(需要破坏类型damage_pipe_info{3})
            net_data_1 = obj.net_data;
            breakpipe=damage_pipe_info{1};
            % first 找到破坏管道中的干路
            D=cell2mat(net_data_1{5,2}(:,5));%直径
            D_damage=D(damage_pipe_info{1});%破坏管道的直径
            index_trunk=breakpipe(D_damage>=610);
            index_distribution=breakpipe(D_damage<610);
            % scend 找到断开和泄露破坏
            % 2.1干路断开和泄露
            [~,index_trunk_Indamage]=ismember(index_trunk,damage_pipe_info{1});
            index_trunk_break=index_trunk(damage_pipe_info{3}(index_trunk_Indamage,1)==2);
            index_trunk_leak=index_trunk(damage_pipe_info{3}(index_trunk_Indamage,1)==1);
            % 2.2支路断开和泄露
            [~,index_distribution_Indamage]=ismember(index_distribution,damage_pipe_info{1});
            index_distribution_break=index_distribution(damage_pipe_info{3}(index_distribution_Indamage,1)==2);
            index_distribution_leak=index_distribution(damage_pipe_info{3}(index_distribution_Indamage,1)==1);
            % third 距离水源的距离
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

