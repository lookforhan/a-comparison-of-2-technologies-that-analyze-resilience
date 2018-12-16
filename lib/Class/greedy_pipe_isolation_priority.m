classdef greedy_pipe_isolation_priority < handle
    %greedy_pipe_priority ����̰���㷨��ȷ���ƻ��ܵ����޸�����
    %   1.ȷ��������򷽷�
    properties
        lib_name = 'EPANETx64PDD' % �������ö�̬���ӿ�����
        errcode
    end
    properties % �������
        net_data % ������Ϣ
        break_pipe_id % �ƻ��ܵ���Ϣ
        isolation_time % ��Ҫ����Ĺܵ��ĸ���ʱ��
        inp_file % �ƻ�����inp�ļ�
        pipe_relative % �ܵ����¼ӹܵ���ϵ
    end
    properties(Dependent) % �м����
        n_break_pipe % �ƻ��ܵ�����������ܵ�������
        current_system_serviceablity % ��ǰ����״̬��ϵͳ��ˮ������
        node_id % ���������û��ڵ�id
        pipe_id % �������йܵ�id
        input_check % �����������Ƿ�ƥ�䣺1ƥ�䣻0��ƥ�䣬��Ҫ��飻
    end
    properties % �м����
    end
    properties % �������
    end
    methods
        function obj = greedy_pipe_isolation_priority(inp_file,net_data,break_pipe_id,isolation_time_mat,pipe_relative)
            obj.inp_file = inp_file;
            obj.net_data = net_data;
            obj.break_pipe_id = break_pipe_id;
            obj.isolation_time = isolation_time_mat;
            obj.pipe_relative = pipe_relative;
            if libisloaded(obj.lib_name)
                disp([obj.lib_name,'is loaded.'])
            else
                disp([obj.lib_name,'is NOT loaded!!'])
            end
        end
        function Run(obj)
            for i = 1: obj.n_break_pipe
            end
        end
    end
    methods % get
        function n_break_pipe = get.n_break_pipe(obj)
            n_break_pipe = numel(obj.break_pipe_id);
        end
        function node_id = get.node_id(obj)
            node_id = obj.net_data{2,2}(:,1);
        end
        function input_check = get.input_check(obj)
            input_check.break_pipe_id_with_pipe_relative = all(ismember(obj.break_pipe_id,obj.pipe_relative(:,1)));
            input_check.pipe_relative_with_pipe_id = all(ismember(obj.pipe_relative(:,1),obj.pipe_id));
        end

        function pipe_id = get.pipe_id(obj)
            pipe_id = obj.net_data{5,2}(:,1);
        end

        function current_system_serviceablity = get.current_system_serviceablity(obj)
            obj.errcode.ENopen = calllib(obj.lib_name,'ENopen',obj.inp_file,[obj.inp_file(1:end-4),'current','.rpt'],'');
            obj.errcode.ENsettimeparam = calllib(obj.lib_name,'ENsettimeparam',0,0);% ����ģ����ʱ
            obj.errcode.ENsetoption = calllib(obj.lib_name,'ENsetoption',0,500);% ��̬���ӿ��е�������
            obj.errcode.ENsloveH = calllib(obj.lib_name,'ENsolveH');
            [~,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
            current_system_serviceablity = sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
            obj.errcode.ENreport = calllib(obj.lib_name,'ENreport');
            obj.errcode.ENclose = calllib(obj.lib_name,'ENclose');
        end
    end
end

