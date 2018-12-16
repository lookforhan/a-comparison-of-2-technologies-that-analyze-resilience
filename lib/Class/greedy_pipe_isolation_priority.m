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
    end
    properties % �м����
    end
    properties % �������
        damage_isolation_inp
        isolated_pipe_id
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
        function current_system_serviceablity = get.current_system_serviceablity(obj)
            obj.errcode.ENopen = calllib(obj.lib_name,'ENopen',obj.inp_file,[obj.inp_file(1:end-4),'current','.rpt'],'');
            obj.errcode.ENsettimeparam = calllib(obj.lib_name,'ENsettimeparam',0,0);% ����ģ����ʱ
            obj.errcode.ENsetoption = calllib(obj.lib_name,'ENsetoption',0,500);% ��̬���ӿ��е�������
            obj.errcode.ENsloveH = calllib(obj.lib_name,'ENsolveH');
            %             obj.errcode.ENopenH = calllib(obj.lib_name,'ENopenH');
            %             obj.errcode.ENinitH = calllib(obj.lib_name,'ENinitH',0);
            %             temp_t = 0;
            %             temp_tstep = 1;
            %             time_step_n =0;
            %             obj.errcode.ENrunH = 0;
            %             obj.errcode.ENnextH = 0;
            %             while (temp_tstep && ~obj.errcode.ENrunH && ~obj.errcode.ENnextH)
            %                 [obj.errcode.ENrunH,temp_t] = calllib(obj.lib_name,'ENrunH',temp_t);
            %                 [real_pre_chosen_node,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
            %                 current_system_serviceablity = sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
            %                 [obj.errcode.ENnextH,temp_tstep]=calllib(obj.lib_name,'ENnextH',temp_tstep);
            %             end
            [~,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
            current_system_serviceablity = sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
            obj.errcode.ENreport = calllib(obj.lib_name,'ENreport');
            obj.errcode.ENclose = calllib(obj.lib_name,'ENclose');
        end
    end
end

