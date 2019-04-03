classdef Create_damage_info < handle
    %Create_damage_info 根据泄露点和断开点数量随机生成标准破坏信息文件
    %   此处显示详细说明
    
    properties % input
        damage_pipe_num % 总破坏点数量
        break_pipe_num % 断开点数量
        out_file % 生成文件地址和名称
        net_data % 管网信息
    end
    properties(SetAccess = private) % check
        errcode
        break_pipe_id
        damage_pipe_id
    end
    properties(Dependent,SetAccess = private)
        pipe_id
        pipe_diameter
    end
    methods
        function obj = Create_damage_info(Damage_pipe_num,Break_pipe_num,Out_file_name,Net_data)
            obj.damage_pipe_num = Damage_pipe_num;
            obj.break_pipe_num = Break_pipe_num;
            obj.out_file = Out_file_name;
            obj.net_data = Net_data;
            obj.errcode.write_Damagefile = 0;
            obj.errcode.ND_Execut_deterministic1 =0;
            
        end
        function Run(obj)
            disp([mfilename,':Run']);
            damage_equ_diameter = zeros(obj.damage_pipe_num,1);
            randnum = randperm(numel(obj.pipe_id));
            obj.damage_pipe_id = obj.pipe_id(randnum(1:obj.damage_pipe_num));% 破坏管道id
            damage_pipe_diameter = obj.pipe_diameter(randnum(1:obj.damage_pipe_num));
            damage_pipe_class_1 = ones(numel(obj.damage_pipe_id),1);
            randnum_2 = randperm(numel(obj.damage_pipe_id));
            obj.break_pipe_id = obj.damage_pipe_id(randnum_2(1:obj.break_pipe_num));
            damage_pipe_class_1(randnum_2(1:obj.break_pipe_num)) =2;
            damage_equ_diameter(damage_pipe_class_1==2) = cell2mat(damage_pipe_diameter(damage_pipe_class_1==2));
            damage_equ_diameter(damage_pipe_class_1==1) = cell2mat(damage_pipe_diameter(damage_pipe_class_1==1))*0.25;
            damage_node_num = ones(obj.damage_pipe_num,1);
            damage_node_distance = ones(obj.damage_pipe_num,1)*0.5;
            damage_node_priority = (1:obj.damage_pipe_num)';
            damage_data = {damage_node_priority,obj.damage_pipe_id,damage_node_num,damage_node_distance,damage_pipe_class_1,damage_equ_diameter};
            [obj.errcode.ND_Execut_deterministic1,damage_pipe_info] = ND_Execut_deterministic1(obj.net_data,damage_data);            
            [ obj.errcode.write_Damagefile ] = write_Damagefile( damage_pipe_info, obj.out_file );%生成破坏文件
        end
    end
    methods
        function pipe_id = get.pipe_id(obj)
            pipe_id = obj.net_data{5,2}(:,1);
        end
        function pipe_diameter = get.pipe_diameter(obj)
            pipe_diameter = obj.net_data{5,2}(:,5);
        end
    end  
end

