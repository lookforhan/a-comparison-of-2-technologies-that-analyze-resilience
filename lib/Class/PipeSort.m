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
    end
    
    methods
        function obj = PipeSort(net_data,pipeID)
            obj.diameter = net_data{5,2}(:,5);
            obj.ID = net_data{5,2}(:,1);
            obj.net_data = net_data;
            obj.chosenPipeID = pipeID;
        end
        function SortDiameter(obj)
            theChosenPipe = obj.chosenPipeID;
            [~,theLoc] = ismember(theChosenPipe,obj.ID);
            theChosenPipeDiameter = obj.diameter(theLoc);
            theData = [theChosenPipe,theChosenPipeDiameter];
            theNewData = sortrows(theData,2);
            obj.sortPipeDiameter = flipud(theNewData (:,2));
            obj.sortPipeID = flipud(theNewData (:,1));
        end
    end
    
end

