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
        output_inp_file % ÿ������ģ�����һ���ܵ�����عܵ��Ĺ���
        output_system_serviceablity % ����ĸ���һ���ܵ���Ӧ�Ĺ�ˮ������
    end
    methods
        function obj = greedy_pipe_isolation_priority(inp_file,net_data,break_pipe_id,pipe_relative)
            obj.inp_file = inp_file;
            obj.net_data = net_data;
            obj.break_pipe_id = break_pipe_id;  
            obj.pipe_relative = pipe_relative;
            if libisloaded(obj.lib_name)
                disp([obj.lib_name,'is loaded.'])
            else
                disp([obj.lib_name,'is NOT loaded!!'])
            end
        end
        function Run(obj)
            fid = 1;         
            for i = 1: obj.n_break_pipe
                obj.errcode.Run.ENopen = calllib(obj.lib_name,'ENopen',obj.inp_file,[obj.inp_file(1:end-4),'_Run','.rpt'],[obj.inp_file(1:end-4),'_Run','.out']);
                obj.errcode.Run.ENsettimeparam = calllib(obj.lib_name,'ENsettimeparam',0,0);% ����ģ����ʱ
                obj.errcode.Run.ENsetoption = calllib(obj.lib_name,'ENsetoption',0,500);% ��̬���ӿ��е�������
                the_current_break_id = obj.break_pipe_id{i,1};
                obj.output_inp_file{i} = [obj.inp_file(1:end-4),'_isolate_',the_current_break_id,'.inp'];
                [~,the_current_break_id_loc] = ismember(the_current_break_id,obj.pipe_relative(:,1));
                for j = 1:numel(obj.pipe_relative{the_current_break_id_loc,2})
                    id = libpointer('cstring',obj.pipe_relative{the_current_break_id_loc,2}{1,j});
                    fprintf(fid,'����ܵ�:%s\r\n',obj.pipe_relative{the_current_break_id_loc,2}{1,j} );
                    index =libpointer('int32Ptr',0);
                    [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                    if code
                        disp(num2str(code));
                        keyboard
                    end
                    code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,0);%�ܵ�id״̬Ϊ�ر�
                    if code
                        disp(num2str(code));
                        fprintf(fid,'����ܵ�:%s����,����%s\r\n',id,num2str(code) );
                        keyboard
                    end
                    code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,0);
                    if code
                        disp(num2str(code));
                        fprintf(fid,'����ܵ�:%s����,����%s\r\n',id,num2str(code) );
                        keyboard
                    end
                end
                obj.errcode.Run.ENsolveH = calllib(obj.lib_name,'ENsolveH');
                obj.errcode.Run.ENsaveinpfile = calllib(obj.lib_name,'ENsaveinpfile',obj.output_inp_file{i});
                [~,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
                obj.output_system_serviceablity(i,1) = sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
                obj.errcode.Run.ENclose = calllib(obj.lib_name,'ENclose');
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
            obj.errcode.CSS.ENopen = calllib(obj.lib_name,'ENopen',obj.inp_file,[obj.inp_file(1:end-4),'current','.rpt'],'');
            obj.errcode.CSS.ENsettimeparam = calllib(obj.lib_name,'ENsettimeparam',0,0);% ����ģ����ʱ
            obj.errcode.CSS.ENsetoption = calllib(obj.lib_name,'ENsetoption',0,500);% ��̬���ӿ��е�������
            obj.errcode.CSS.ENsloveH = calllib(obj.lib_name,'ENsolveH');
            [~,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
            current_system_serviceablity = sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
            obj.errcode.CSS.ENreport = calllib(obj.lib_name,'ENreport');
            obj.errcode.CSS.ENclose = calllib(obj.lib_name,'ENclose');
        end
    end
end

