classdef Create_damage_info < handle
    %Create_damage_info ����й¶��ͶϿ������ɱ�׼�ƻ���Ϣ�ļ�
    %   2019/5/16 ÿ���ܶ�����һ���ƻ��㣬���Ͽ�/й©��
    % t = Create_damage_info(net_data)
    % t.break_pipe_id = {'2';'5'};
    % t.leak_pipe_id = {'6';'9';'13'};
    % t.Run
    % t.export_txt('damage_info.txt')
    properties % input
        net_data % ������Ϣ,�����н���Ҫ�ܶ�id��ֱ��
    end
    properties % check
        errcode
        break_pipe_id
        leak_pipe_id
        damage_info;
        out_data % ��������ݣ�Ԫ�����顣�Ժ��޸�Ϊtable����
    end
    properties(Dependent,SetAccess = private)
        pipe_id
        pipe_diameter
        damage_pipe_id
        damage_pipe_num % ���ƻ�������
        break_pipe_num % �Ͽ�������
        leak_pipe_num % й©������
        damage_pipe_id_check_code %���ѡ����ƻ��ܶ�id�Ƿ��ڹ����ļ���
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
                disp('���¼��ܶ�id:')
                err_pipe_id = obj.damage_pipe_id(obj.damage_pipe_id_check_code == 0);
                for i = 1:numel(err_pipe_id)
                    disp(err_pipe_id{i});
                end
            end
            obj.damageInfo2out_data;
            
        end
        function damageInfo2out_data(obj)
            
            obj.out_data = cell(obj.damage_pipe_num+1,6);
            obj.out_data{1,1} = '�ƻ����';
            obj.out_data{1,2} = '���ڹ��߱��';
            obj.out_data{1,3} = '�ù������ƻ��ƻ�����';
            obj.out_data{1,4} = '�ƻ�����ǰ��֮�䳤�ȱ���';
            obj.out_data{1,5} = '�ƻ�����';
            obj.out_data{1,6} = '��©�����Чֱ����mm��';          
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
                    obj.out_data{j,5} = 2;%�Ͽ�
                    obj.out_data{j,6} = cell2mat(equationDiameter);
                else
                    obj.out_data{j,5} = 1;%й©
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
