classdef greedy_pipe_recovery_priority < handle
    %greedy_pipe_priority ����̰���㷨��ȷ���ƻ��ܵ����޸�����
    %   1.ȷ��������򷽷�
    properties
        lib_name = 'EPANETx64PDD' % �������ö�̬���ӿ�����
        errcode
        disp_key_word = 1; % �ؼ��ʣ�1�������0�����
    end
    properties % �������
        net_data % ������Ϣ
        break_pipe_id % �ƻ��ܵ���Ϣ
        inp_file % �ƻ�����inp�ļ�
        pipe_relative % �ܵ����¼ӹܵ���ϵ
        out_dir
        Pipe_flag
        Valve_segment
        pipeID
    end
    properties(Dependent) % �м����
        n_break_pipe % �ƻ��ܵ�����������ܵ�������
        current_system_serviceability % ��ǰ����״̬��ϵͳ��ˮ������
        node_id % ���������û��ڵ�id
        pipe_id % �������йܵ�id
        input_check % �����������Ƿ�ƥ�䣺1ƥ�䣻0��ƥ�䣬��Ҫ��飻
    end
    properties % �м����
    end
    properties % �������
        output_inp_file % ÿ������ģ�����һ���ܵ�����عܵ��Ĺ���
        output_system_serviceability % ����ĸ���һ���ܵ���Ӧ�Ĺ�ˮ������
    end
    methods
        function obj = greedy_pipe_recovery_priority(inp_file,net_data,break_pipe_id,pipe_relative)
            obj.inp_file = inp_file;
            obj.net_data = net_data;
            obj.break_pipe_id = break_pipe_id;
            obj.pipe_relative = pipe_relative;
            if libisloaded(obj.lib_name)
                if obj.disp_key_word ==0
                    disp([obj.lib_name,' is loaded.'])
                end
            else
                disp([obj.lib_name,'is NOT loaded!!'])
            end
             load('mod_segment.mat')
            obj.Pipe_flag = pipe_flag;
            obj.Valve_segment = valve_pipe_segment;
            obj.pipeID = link.pipeID;
        end
        function Run(obj)
            log_file = ['greedy','recovery_Run_debug_.','log'];
            fid_log_file = fopen(log_file,'w');
            fid = 1;
            global n_ENrun
            for i = 1: obj.n_break_pipe
                 fprintf(fid_log_file,'����ܵ�=====\n' );
                obj.errcode.Run.ENopen = calllib(obj.lib_name,'ENopen',obj.inp_file,[obj.inp_file(1:end-4),'_Run','.rpt'],[obj.inp_file(1:end-4),'_Run','.out']);
                obj.errcode.Run.ENsettimeparam = calllib(obj.lib_name,'ENsettimeparam',0,0);% ����ģ����ʱ
                obj.errcode.Run.ENsetoption = calllib(obj.lib_name,'ENsetoption',0,500);% ��̬���ӿ��е�������
                the_current_break_id = obj.break_pipe_id{i,1};
                obj.output_inp_file{i} = [obj.out_dir,'_recovery_',the_current_break_id,'.inp'];
                [~,the_current_break_id_loc] = ismember(the_current_break_id,obj.pipe_relative(:,1));
                the_pipe = obj.break_pipe_id{i,1};
                [~,the_pipe_segment_loc] = ismember(the_pipe,obj.pipeID);
                the_pipe_segment = obj.Pipe_flag(the_pipe_segment_loc);
                the_segment_pipe_close = obj.Valve_segment(the_pipe_segment);
                fprintf(fid_log_file,'�򿪹ܵ�:%s\r\n',the_pipe );
                for p = 1:numel(the_segment_pipe_close{1}) % ���������ڹܵ����ر�
                    id = libpointer('cstring',the_segment_pipe_close{1}{p,1});
                    index =libpointer('int32Ptr',0);
                    [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                    code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,1);%�ܵ�id״̬Ϊ����
                    fprintf(fid_log_file,'�򿪷��Źܵ�:%s\r\n',the_segment_pipe_close{1}{p,1} );
                end
                index =libpointer('int32Ptr',0);
                
                for j = 1:numel(obj.pipe_relative{the_current_break_id_loc,2})
                    id = libpointer('cstring',obj.pipe_relative{the_current_break_id_loc,2}{1,j});
                    if obj.disp_key_word ==0
                        fprintf(fid,'����ܵ�:%s\r\n',obj.pipe_relative{the_current_break_id_loc,2}{1,j} );
                    end
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
                id = libpointer('cstring',obj.pipe_relative{the_current_break_id_loc,1});
                [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                if code
                    disp(num2str(code));
                    keyboard
                end
                code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,1);%�ܵ�id״̬Ϊ����
                if code
                    disp(num2str(code));
                    fprintf(fid,'����ܵ�:%s����,����%s\r\n',id,num2str(code) );
                    keyboard
                end
                code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,1);
                if code
                    disp(num2str(code));
                    fprintf(fid,'����ܵ�:%s����,����%s\r\n',id,num2str(code) );
                    keyboard
                end
                obj.errcode.Run.ENsolveH = calllib(obj.lib_name,'ENsolveH');
                n_ENrun = n_ENrun +1;
                obj.errcode.Run.ENsaveinpfile = calllib(obj.lib_name,'ENsaveinpfile',obj.output_inp_file{i});
                [~,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
                [outputArg1] = calculate_SSI(cal_demand_chosen_node,req_demand_chosen_node);
%                              new_cal_demand_chosen_node = cal_demand_chosen_node;%����������Ҫ���쳣�Ľڵ���ˮ�����е���
%                 new_cal_demand_chosen_node(cal_demand_chosen_node<0) = 0; %������ˮ��Ϊ��ֵʱ��������ˮ������Ϊ0��
%                 new_cal_demand_chosen_node(cal_demand_chosen_node>req_demand_chosen_node) = 0;%��������ˮ��������ˮ���������Ϊ0��
                 obj.output_system_serviceability(i,1) = outputArg1;
%                 obj.output_system_serviceablity(i,1) = sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
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
        function current_system_serviceablity = get.current_system_serviceability(obj)
            obj.errcode.CSS.ENopen = calllib(obj.lib_name,'ENopen',obj.inp_file,[obj.inp_file(1:end-4),'current','.rpt'],'');
            obj.errcode.CSS.ENsettimeparam = calllib(obj.lib_name,'ENsettimeparam',0,0);% ����ģ����ʱ
            obj.errcode.CSS.ENsetoption = calllib(obj.lib_name,'ENsetoption',0,500);% ��̬���ӿ��е�������
            obj.errcode.CSS.ENsloveH = calllib(obj.lib_name,'ENsolveH');
            [~,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
            [outputArg1] = calculate_SSI(cal_demand_chosen_node,req_demand_chosen_node);
            current_system_serviceablity = outputArg1;
            obj.errcode.CSS.ENreport = calllib(obj.lib_name,'ENreport');
            obj.errcode.CSS.ENclose = calllib(obj.lib_name,'ENclose');
        end
    end
end

