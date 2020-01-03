classdef Create_damage_info < handle
    %Create_damage_info 根据泄露点和断开点生成标准破坏信息文件
    %   2019/5/16 每个管段生成一个破坏点，（断开/泄漏）
    % t = Create_damage_info(net_data)
    % t.break_pipe_id = {'2';'5'};
    % t.leak_pipe_id = {'6';'9';'13'};
    % t.Run
    % t.export_txt('damage_info.txt')
    properties % input
        net_data % 管网信息,本类中仅需要管段id和直径
    end
    properties % check
        errcode
        break_pipe_id
        leak_pipe_id
        damage_info;
        out_data % 输出的数据，元胞数组。以后修改为table类型
    end
    properties(Dependent,SetAccess = private)
        pipe_id
        pipe_diameter
        damage_pipe_id
        damage_pipe_num % 总破坏点数量
        break_pipe_num % 断开点数量
        leak_pipe_num % 泄漏点数量
        damage_pipe_id_check_code %检查选择的破坏管段id是否在管网文件中
    end
    methods
        function obj = Create_damage_info(Net_data)
            obj.net_data = Net_data;
            obj.errcode.write_Damagefile = 0;
            obj.errcode.ND_Execut_deterministic1 =0;
            
        end
        function Run(obj)
            disp([mfilename,':Run']);
            if all(obj.damage_pipe_id_check_code) == 0
                disp('重新检查管段id:')
                err_pipe_id = obj.damage_pipe_id(obj.damage_pipe_id_check_code == 0);
                for i = 1:numel(err_pipe_id)
                    disp(err_pipe_id{i});
                end
            end
            obj.damageInfo2out_data;
            
        end
        function damageInfo2out_data(obj)
            
            obj.out_data = cell(obj.damage_pipe_num+1,6);
            obj.out_data{1,1} = '破坏编号';
            obj.out_data{1,2} = '所在管线编号';
            obj.out_data{1,3} = '该管线上破坏破坏次序';
            obj.out_data{1,4} = '破坏点与前点之间长度比例';
            obj.out_data{1,5} = '破坏类型';
            obj.out_data{1,6} = '渗漏面积等效直径（mm）';          
            for i = 1:obj.damage_pipe_num
                j = i+1;
                obj.out_data{j,1} = i;
                obj.out_data{j,2} = obj.damage_pipe_id{i};
                %                 loc = ismember(obj.pipe_id,obj.damage_pipe_id{i})
                %                 equationDiameter = obj.pipe_diameter(loc);
                %                 PIPE_ID = obj.pipe_id;
                equationDiameter = obj.pipe_diameter(ismember(obj.pipe_id,obj.damage_pipe_id(i)));
                obj.out_data{j,3} = 1;
                obj.out_data{j,4} = 0.5;
                if i<= obj.break_pipe_num
                    obj.out_data{j,5} = 2;%断开
                    obj.out_data{j,6} = cell2mat(equationDiameter);
                else
                    obj.out_data{j,5} = 1;%泄漏
                    obj.out_data{j,6} = cell2mat(equationDiameter)*0.25;
                end
                
            end
            
        end
        function export_txt(obj,out_file)
            txt_data = obj.out_data;
            for i = 1:obj.damage_pipe_num
                j = i+1;
                txt_data{j,1} = num2str(obj.out_data{j,1});
                txt_data{j,3} = num2str(obj.out_data{j,3});
                txt_data{j,4} = num2str(obj.out_data{j,4});
                txt_data{j,5} = num2str(obj.out_data{j,5});
                txt_data{j,6} = num2str(obj.out_data{j,6});
            end
            fid = fopen(out_file,'w');
            for n = 1:(obj.damage_pipe_num+1)
                fprintf(fid,'%s \t %s \t %s \t %s \t %s \t %s',txt_data{n,:});
                fprintf(fid,'\r\n');
            end
            fclose(fid);
        end
        function export_xls(obj,out_file)
            xlswrite(out_file,obj.out_data)
        end
    end
    methods
        function pipe_id = get.pipe_id(obj)
            pipe_id = obj.net_data{5,2}(:,1);
        end
        function pipe_diameter = get.pipe_diameter(obj)
            pipe_diameter = obj.net_data{5,2}(:,5);
        end
        function damage_pipe_id = get.damage_pipe_id(obj)
            damage_pipe_id = [obj.break_pipe_id;obj.leak_pipe_id];
        end
        function damage_pipe_num = get.damage_pipe_num(obj)
            damage_pipe_num = numel(obj.damage_pipe_id);
        end
        function break_pipe_num = get.break_pipe_num(obj)
            break_pipe_num = numel(obj.break_pipe_id);
        end
        function leak_pipe_num = get.leak_pipe_num(obj)
            leak_pipe_num = numel(obj.leak_pipe_id);
        end
        function damage_pipe_id_check_code = get.damage_pipe_id_check_code(obj)
            loc = ismember(obj.damage_pipe_id,obj.pipe_id);
            damage_pipe_id_check_code = loc;
        end
    end
end

