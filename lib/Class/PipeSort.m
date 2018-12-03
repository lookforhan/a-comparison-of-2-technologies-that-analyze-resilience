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

