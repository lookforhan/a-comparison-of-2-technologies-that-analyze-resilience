classdef EPS_net_EPANETx64PDD < handle
    %EPS_net_EPANETx64PDD ����EPANETx64PDD.dll������ʱˮ������
    %   ��EPS_net4_EPANETx64PDD.m�ı���ɣ��������©ˮ���Ĳ�����
    
    properties
        lib_name = 'EPANETx64PDD' % �������ö�̬���ӿ�����
        errcode = 0; % �������
        time_step = 3600 %(s) ʱ�䲽����
    end
    properties % �������
        out_inp % ���������output_net_filename_inp
        out_dir % ���������output_result_dir
        pipe_status % ���������PipeStatus
        pipe_status_change % ���������PipeStatusChange
        pipe_relative % ���������pipe_relative
        net_data % ���������net_data
        duration % ���������duration_one
    end
    properties(Dependent) % �м����
        reservoirs_id % ����ˮԴid
        node_id % ���нڵ�id
        pipe_id % ���й���id
        duration_set % ��ʱģ����ʱ
        timeStep_changePipeStatus % �����仯�Ĺܵ�״̬�����к�
        pipe_status_change_simple % �����仯�Ĺܵ�״̬�����
    end
    properties % �����������
        damage_leakage % ÿ��ʱ�䲽��ÿ���ƻ����©ˮ��
        reservoirs_supply % ÿ��ʱ�䲽��ÿ��ˮԴ��Ĺ�ˮ��
        node_demand_calculate % ÿ��ʱ�䲽��ÿ���ڵ��ʵ�ʹ�ˮ��
        node_pressure_calculate % ÿ��ʱ�䲽��ÿ���ڵ��ʵ��ˮѹ
    end
    properties % �������
        node_serviceability % ÿ��ʱ�䲽���ڵ㹩ˮ������
        system_serviceability % ÿ��ʱ�䲽��ϵͳ��ˮ������
    end
    properties % ��¼
        activity % ÿ��ʱ�䲽����Ϊ
        time % ÿ��ʱ�䲽��Ӧ��ʱ��
    end
    methods
        function obj = EPS_net_EPANETx64PDD( output_net_filename_inp,output_result_dir,PipeStatus,PipeStatusChange,pipe_relative,net_data,...
                duration_one)
            obj.out_inp = output_net_filename_inp;
            obj.out_dir = output_result_dir;
            obj.pipe_status = PipeStatus;
            obj.pipe_status_change = PipeStatusChange;
            obj.pipe_relative = pipe_relative;
            obj.net_data = net_data;
            obj.duration = duration_one;
            if libisloaded(obj.lib_name)
                disp([obj.lib_name,'is loaded.'])
            else
                disp([obj.lib_name,'is NOT loaded!!'])
            end
        end
        function Run(obj)
            obj.errcode(1) = calllib(obj.lib_name,'ENopen',obj.out_inp,[obj.out_inp(1:end-3),'rpt'],'');
        end
        function Run_debug(obj)
            disp('Run_debug��ʼ����')
            log_file = [obj.out_inp(1:end-4),'_Run_debug_.','log'];
            fid = fopen(log_file,'w');
            if fid <=0
                disp([log_file,'�ļ���ʧ��'])
                keyboard
            end
            disp(['��������뿴��',log_file])
            reservoirs_supply_cell = cell(obj.duration,1);
            time_timeStep = cell(obj.duration,1);
            Pre = cell(obj.duration,1);
            cal_Demand = cell(obj.duration,1);
            node_serviceability_cell = cell(obj.duration,1);
            system_serviceability_cell = cell(obj.duration,1);
            activity_cell = cell(obj.duration,1);
            obj.errcode(1) = calllib(obj.lib_name,'ENopen',obj.out_inp,[obj.out_inp(1:end-3),'rpt'],'');
            obj.errcode(2) = calllib(obj.lib_name,'ENsettimeparam',0,obj.duration_set);% ����ģ����ʱ
            obj.errcode(3) = calllib(obj.lib_name,'ENsetoption',0,500);% ��̬���ӿ��е�������
            obj.errcode(4) = calllib(obj.lib_name,'ENopenH');
            obj.errcode(5) = calllib(obj.lib_name,'ENinitH',0);
            temp_t = 0;
            temp_tstep = 1;
            time_step_n =0;
            errcode4 = 0;
            timeStepChose = obj.timeStep_changePipeStatus; %
            newPipeStatusChange = obj.pipe_status_change_simple;
            while (temp_tstep && ~errcode4)
                time_step_n = time_step_n+1;
                if errcode4
                    keyboard
                end
                fprintf(fid,'%s\r\n',num2str(temp_t));
                fprintf(fid,'%s\r\n',num2str(time_step_n));
                [lia,loc] = ismember(time_step_n,timeStepChose);%
                if lia
                    fprintf(fid,'%s\r\n','��ʼ�޸Ĺܵ�״̬');
                    mid_status = newPipeStatusChange(:,loc);
                    str1 = '';
                    str2 = '';
                    str3 = '';
                    
                    for i = 1:numel(mid_status)
                        pipe_status_timeStep = mid_status(i);
                        switch  pipe_status_timeStep
                            case 0
                                str1 = '�޶���;';
                                %                                 continue %
                            case 1
                                % isolation
                                str2 = [str2,'����ܵ�',obj.pipe_relative{i,1},';'];
                                for j =1:numel(obj.pipe_relative{i,2})% ����Ĺܵ�Ϊ��ǰ�ܵ���������ƻ��ܵ���
                                    id = libpointer('cstring',obj.pipe_relative{i,2}{1,j});
                                    fprintf(fid,'����ܵ�:%s\r\n',obj.pipe_relative{i,2}{1,j} );
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
                            case 2
                                %isolation
                                str3 = [str3,'����ܵ�',obj.pipe_relative{i,1},';'];
                                for j =1:numel(obj.pipe_relative{i,2})% ����Ĺܵ�Ϊ��ǰ�ܵ���������ƻ��ܵ���
                                    id = libpointer('cstring',obj.pipe_relative{i,2}{1,j});
                                    fprintf(fid,'����ܵ�:%s\r\n',obj.pipe_relative{i,2}{1,j} );
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
                                %reopen
                                str3 = [str3,'�޸��ܵ�',obj.pipe_relative{i,1},';'];
                                id=libpointer('cstring',obj.pipe_relative{i,1});
                                index =libpointer('int32Ptr',0);
                                [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                                
                                if code
                                    disp(nem2str(code));
                                    keyboard
                                end
                                code= calllib(obj.lib_name,'ENsetlinkvalue',index,11,1);
                                if code
                                    disp(nem2str(code));
                                    fprintf(fid,'reopen�ܵ�:%s����,����%s\r\n',id,num2str(code) );
                                    keyboard
                                end
                                code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,1);
                                fprintf(fid,'reopen�ܵ�%s,\r\n',obj.pipe_relative{i,1});
                                if code
                                    disp(nem2str(code));
                                    fprintf(fid,'reopen�ܵ�:%s����,����%s\r\n',id,num2str(code) );
                                    keyboard
                                end
                        end
                        
                    end
                    str = [str1,str2,str3];
                    fprintf(fid,'%sʱ��,�ܵ�״̬�޸����\r\n',num2str(temp_t) );
                else
                    str = '�޶���';
                    fprintf(fid,'%sʱ��,�ܵ�״̬�����޸����\r\n',num2str(temp_t) );
                end
                [errcode4,temp_t] = calllib(obj.lib_name,'ENrunH',temp_t);
                if errcode4
                    disp(nem2str(code));
                    fprintf(fid,'ENrunH����,����%s\r\n',num2str(errcode4) );
                    keyboard
                end
                time_timeStep{time_step_n} = temp_t;
                [real_pre_chosen_node,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
                [~,cal_demand_chosen_reservoirs,~]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.reservoirs_id);
                Pre{time_step_n} = real_pre_chosen_node;
                %                 Demand{time_step_n}=req_demand_chosen_node;
                cal_Demand{time_step_n}=cal_demand_chosen_node;
                system_serviceability_cell{time_step_n}= sum(cal_demand_chosen_node)/sum(req_demand_chosen_node);
                node_serviceability_cell{time_step_n} =  cal_demand_chosen_node./req_demand_chosen_node;
                reservoirs_supply_cell{time_step_n} = cal_demand_chosen_reservoirs;
                activity_cell{time_step_n} = str;%��¼ÿ��ʱ�䲽����Ϊ
                leakage_water_cell{time_step_n} = sum( cal_demand_chosen_reservoirs)+sum(cal_demand_chosen_node);
                [errcode4,temp_tstep]=calllib(obj.lib_name,'ENnextH',temp_tstep);
            end
            fclose(fid);
            obj.activity = activity_cell;
            obj.system_serviceability = system_serviceability_cell;
            obj.node_demand_calculate = cal_Demand;
            obj.node_pressure_calculate = Pre;
            obj.time = time_timeStep;
            obj.node_serviceability = node_serviceability_cell;
            obj.reservoirs_supply = reservoirs_supply_cell;
            obj.leakage.sum = leakage_water_cell;
            disp('Run_debug��������')
        end
        
    end
    methods
        function reservoirs_id = get.reservoirs_id(obj)
            reservoirs_id = obj.net_data{3,2}(:,1);
        end
        function node_id = get.node_id(obj)
            node_id = obj.net_data{2,2}(:,1);
        end
        function pipe_id = get.pipe_id(obj)
            pipe_id = obj.net_data{5,2}(:,1);
        end
        function duration_set = get.duration_set(obj)
            duration_set = (obj.duration-1)*obj.time_step;
        end
        function timeStep_changePipeStatus = get.timeStep_changePipeStatus(obj)
            [newPipeStatus_1,ia,~]=unique(obj.pipe_status','rows');
            newPipeStatus_2=[ia,newPipeStatus_1];
            newPipeStatus_3=sortrows(newPipeStatus_2);
            newPipeStatus_4=newPipeStatus_3;
            newPipeStatus=newPipeStatus_4';
            timeStep_changePipeStatus = newPipeStatus(1,:);
        end
        function pipe_status_change_simple = get.pipe_status_change_simple(obj)
            [newPipeStatus_1,ia,~]=unique(obj.pipe_status_change','rows');
            newPipeStatus_2=[ia,newPipeStatus_1];
            newPipeStatus_3=sortrows(newPipeStatus_2);
            newPipeStatus_4=newPipeStatus_3;
            newPipeStatus=newPipeStatus_4';
            pipe_status_change_simple = newPipeStatus(2:end,:);
        end
    end
end

