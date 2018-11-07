classdef ga_uniq_individual <handle
    %ga_uniq_individual 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        pop_init
        pop_uniq
    end
    
    methods
        function obj = ga_uniq_individual(newPop)
            obj.pop_init = newPop;
        end
        function delete(obj)
        end
        function uniq(obj)
            indivdual_mat = [];
            for i = 1:numel(obj.pop_init)
                ndividual_mat = [individual_mat,cell2mat(pop_init{i})];
            end
            [individual_mat_tran,ia,ic] = unique(individual_mat','rows');
            obj.pop_uniq = obj.pop_init(ia);
        end
        
    end
    
end

