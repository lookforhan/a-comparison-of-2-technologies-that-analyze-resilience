classdef EPS_net_EPANETx64PDD < handle
    %EPS_net_EPANETx64PDD 调用EPANETx64PDD.dll进行延时水力分析
    %   由EPS_net4_EPANETx64PDD.m改编而成，增加输出漏水量的参数。
    
    properties
        lib_name = 'EPANETx64PDD' % 计算所用动态链接库名称
        errcode = 0; % 错误代码
        time_step = 3600 %(s) 时间步长；
        calculate_code; % 判断每个时间步计算结果可靠度
        dispKeyWord = 0; % 输出显示关键词，调试用。0不输出，1输出。
        export_inp = 0; % 是否输出每一次水力分析的Inp文件。0不输出，1输出。
        setIterationNumber = 500;% 水力计算迭代次数
    end
    properties % 输入参数
        out_inp % 输入参数：output_net_filename_inp
        out_dir % 输入参数：output_result_dir
        pipe_status % 输入参数：PipeStatus
        pipe_status_change % 输入参数：PipeStatusChange
        pipe_relative % 输入参数：pipe_relative
        net_data % 输入参数：net_data
        duration % 输入参数：duration_one
        Pipe_flag % 识别管道的分区
        Segment % 分区中的管道
        Valve_segment % 边界管道的分区
    end
    properties(Dependent) % 中间参数
        reservoirs_id % 所有水源id
        node_id % 所有节点id
        pipe_id % 所有管线id
        duration_set % 延时模拟历时
        timeStep_changePipeStatus % 发生变化的管道状态矩阵列号
        pipe_status_change_simple % 发生变化的管道状态矩阵简化
    end
    properties % 基本输出参数
        damage_leakage % 每个时间步，每个破坏点的漏水量
        reservoirs_supply % 每个时间步，每个水源点的供水量
        node_demand_calculate % 每个时间步，每个节点的实际供水量
        node_pressure_calculate % 每个时间步，每个节点的实际水压
    end
    properties % 输出参数
        node_serviceability % 每个时间步，节点供水满意率
        system_serviceability % 每个时间步，系统供水满意率
        adjust_demand
    end
    properties % 记录
        activity % 每个时间步的行为
        time % 每个时间步对应的时间
        ENrun_num =0;
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
            obj.calculate_code = zeros(duration_one,1);
            if libisloaded(obj.lib_name)
                if obj.dispKeyWord == 1
                    disp([obj.lib_name,' is loaded.'])
                end
            else
                disp([obj.lib_name,' is NOT loaded!!'])
                keyboard
            end
            load('mod_segment.mat')
            obj.Pipe_flag = pipe_flag;
            obj.Segment = segment;
            obj.Valve_segment = valve_pipe_segment;
        end
        function Run(obj)
            obj.errcode(1) = calllib(obj.lib_name,'ENopen',obj.out_inp,[obj.out_inp(1:end-3),'rpt'],'');
        end
    end
    methods %
        function Run_single(obj) %仅计算初始时刻
            if obj.dispKeyWord == 1
                disp('Run_single开始运行')
            end
            global n_ENrun
            log_file = [obj.out_inp(1:end-4),'_Run_single_.','log'];
            fid_log_file = fopen(log_file,'w');
            if fid_log_file <=0
                disp([log_file,'文件打开失败'])
                keyboard
            end
            if obj.dispKeyWord ==1
                disp(['计算过程请看：',log_file])
            end
            reservoirs_supply_cell = cell(obj.duration,1);
            time_timeStep = cell(obj.duration,1);
            Pre = cell(obj.duration,1);
            cal_Demand = cell(obj.duration,1);
            node_serviceability_cell = cell(obj.duration,1);
            system_serviceability_cell = cell(obj.duration,1);
            leakage_water_mat = zeros(obj.duration,1);
            activity_cell = cell(obj.duration,1);
            obj.errcode(1) = calllib(obj.lib_name,'ENopen',obj.out_inp,[obj.out_inp(1:end-3),'rpt'],'');
            if obj.errcode(1) > 100
                keyboard
            end
            obj.errcode(2) = calllib(obj.lib_name,'ENsettimeparam',0,obj.duration_set);% 设置模拟历时
            obj.errcode(3) = calllib(obj.lib_name,'ENsetoption',0,obj.setIterationNumber);% 动态链接库中迭代次数
            obj.errcode(4) = calllib(obj.lib_name,'ENopenH');
            obj.errcode(5) = calllib(obj.lib_name,'ENinitH',0);
            temp_t = 0;
            temp_tstep = 1;
            time_step_n =0;
            errcode4 = 0;
            code_break = 1;
            timeStepChose = obj.timeStep_changePipeStatus; %
            newPipeStatusChange = obj.pipe_status_change_simple;
            while (temp_tstep && ~errcode4 && code_break)
                time_step_n = time_step_n+1;
                if errcode4
                    keyboard
                end
                fprintf(fid_log_file,'%s\r\n',num2str(temp_t));
                fprintf(fid_log_file,'%s\r\n',num2str(time_step_n));
                [lia,loc] = ismember(time_step_n,timeStepChose);%
                if lia
                    fprintf(fid_log_file,'%s\r\n','开始修改管道状态');
                    mid_status = newPipeStatusChange(:,loc);
                    str2 = blanks(200);
                    str3 = blanks(200);
                    str2_n = 1;
                    str3_n = 1;
                    for i = 1:numel(mid_status)
                        pipe_status_timeStep = mid_status(i);
                        switch  pipe_status_timeStep
                            case 0
                                str1 = '无动作;';
                                %                                 continue %
                            case 1
                                % isolation
                                mid_str = ['隔离管道',obj.pipe_relative{i,1},';'];
                                str_length = length(mid_str);
                                str2(str2_n:str2_n+str_length-1) = mid_str;
                                str2_n = str2_n+str_length;
                                for j =1:numel(obj.pipe_relative{i,2})% 隔离的管道为当前管道相关联的破坏管道。
                                    id = libpointer('cstring',obj.pipe_relative{i,2}{1,j});
                                    fprintf(fid_log_file,'隔离管道:%s\r\n',obj.pipe_relative{i,2}{1,j} );
                                    index =libpointer('int32Ptr',0);
                                    [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                                    if code
                                        disp(num2str(code));
                                        keyboard
                                    end
                                    code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,0);%管道id状态为关闭
                                    if code
                                        disp(num2str(code));
                                        fprintf(fid_log_file,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                                        keyboard
                                    end
                                    code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,0);
                                    if code
                                        disp(num2str(code))
                                        fprintf(fid_log_file,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                                        keyboard
                                    end
                                end
                            case 2
                                %isolation
                                mid_str_1 = ['隔离管道',obj.pipe_relative{i,1},';'];
                                str_length = length(mid_str_1);
                                str3(str3_n:str3_n+str_length-1) = mid_str_1;
                                str3_n = str3_n+str_length;
                                for j =1:numel(obj.pipe_relative{i,2})% 隔离的管道为当前管道相关联的破坏管道。
                                    id = libpointer('cstring',obj.pipe_relative{i,2}{1,j});
                                    fprintf(fid_log_file,'隔离管道:%s\r\n',obj.pipe_relative{i,2}{1,j} );
                                    index =libpointer('int32Ptr',0);
                                    [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                                    if code
                                        disp(num2str(code));
                                        keyboard
                                    end
                                    code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,0);%管道id状态为关闭
                                    if code
                                        disp(num2str(code));
                                        fprintf(fid_log_file,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                                        keyboard
                                    end
                                    code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,0);
                                    if code
                                        disp(num2str(code));
                                        fprintf(fid_log_file,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                                        keyboard
                                    end
                                end
                                %reopen
                                mid_str_2 = ['修复管道',obj.pipe_relative{i,1},';'];
                                str_lenth = length(mid_str_2);
                                str3(str3_n:str3_n+str_lenth-1) = mid_str_2;
                                str3_n = str3_n+str_lenth;
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
                                    fprintf(fid_log_file,'reopen管道:%s出错,代码%s\r\n',id,num2str(code) );
                                    keyboard
                                end
                                code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,1);
                                fprintf(fid_log_file,'reopen管道%s,\r\n',obj.pipe_relative{i,1});
                                if code
                                    disp(nem2str(code));
                                    fprintf(fid_log_file,'reopen管道:%s出错,代码%s\r\n',id,num2str(code) );
                                    keyboard
                                end
                        end
                        
                    end
                    str = [str1,deblank(str2),deblank(str3)];
                    fprintf(fid_log_file,'%s时刻,管道状态修改完毕\r\n',num2str(temp_t) );
                else
                    str = '无动作';
                    fprintf(fid_log_file,'%s时刻,管道状态无需修改完毕\r\n',num2str(temp_t) );
                end
                [errcode4,temp_t] = calllib(obj.lib_name,'ENrunH',temp_t);
                obj.ENrun_num = obj.ENrun_num +1;
                n_ENrun = n_ENrun +1;
                obj.calculate_code(time_step_n) = errcode4;
                if errcode4
                    %                     disp(num2str(errcode4));
                    fprintf(fid_log_file,'ENrunH出错,代码%s\r\n',num2str(errcode4) );
                    if errcode4 <100
                        %                         disp(num2str(errcode4))
                    else
                        keyboard
                    end
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
                activity_cell{time_step_n} = str;%记录每个时间步的行为
                leakage_water_mat(time_step_n) = sum( cal_demand_chosen_reservoirs)+sum(cal_demand_chosen_node);
                [errcode4,temp_tstep]=calllib(obj.lib_name,'ENnextH',temp_tstep);
                code_break = 0;
            end
            fclose(fid_log_file);
            obj.errcode(6) = calllib(obj.lib_name,'ENclose');
            obj.activity = activity_cell;
            obj.system_serviceability = system_serviceability_cell;
            obj.node_demand_calculate = cal_Demand;
            obj.node_pressure_calculate = Pre;
            obj.time = time_timeStep;
            obj.node_serviceability = node_serviceability_cell;
            obj.reservoirs_supply = reservoirs_supply_cell;
            obj.damage_leakage.sum = leakage_water_mat;
            if obj.dispKeyWord ==1
                disp('Run_single结束运行')
            end
        end
    end
    
    methods
        
        function Run_debug(obj) %延时模拟，计算时间段内所有时间步
            if obj.dispKeyWord == 1
                disp('Run_debug开始运行')
            end
            global n_ENrun
            log_file = [obj.out_inp(1:end-4),'_Run_debug_.','log'];
            fid_log_file = fopen(log_file,'w');
            if fid_log_file <=0
                disp([log_file,'文件打开失败'])
                keyboard
            end
            if obj.dispKeyWord ==1
                disp(['计算过程请看：',log_file])
            end
            reservoirs_supply_cell = cell(obj.duration,1);
            time_timeStep = cell(obj.duration,1);
            Pre = cell(obj.duration,1);
            cal_Demand = cell(obj.duration,1);
            adjust_Demand = cell(obj.duration,1);
            node_serviceability_cell = cell(obj.duration,1);
            system_serviceability_cell = cell(obj.duration,1);
            leakage_water_mat = zeros(obj.duration,1);
            activity_cell = cell(obj.duration,1);
            obj.errcode(1) = calllib(obj.lib_name,'ENopen',obj.out_inp,[obj.out_inp(1:end-3),'rpt'],'');
            if obj.errcode(1) ~= 0
                keyboard
            end
            obj.errcode(2) = calllib(obj.lib_name,'ENsettimeparam',0,obj.duration_set);% 设置模拟历时
            obj.errcode(3) = calllib(obj.lib_name,'ENsetoption',0,obj.setIterationNumber);% 动态链接库中迭代次数
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
                fprintf(fid_log_file,'%s\r\n',num2str(temp_t));
                fprintf(fid_log_file,'%s\r\n',num2str(time_step_n));
                [lia,loc] = ismember(time_step_n,timeStepChose);%
                if lia
                    fprintf(fid_log_file,'%s\r\n','开始修改管道状态');
                    mid_status = newPipeStatusChange(:,loc);
                    str2 = blanks(200);
                    str3 = blanks(200);
                    str2_n = 1;
                    str3_n = 1;
                    for i = 1:numel(mid_status)
                        pipe_status_timeStep = mid_status(i);
                        switch  pipe_status_timeStep
                            case 0
                                str1 = 'No action;';
                                %                                 continue %
                            case 1
                                % isolation
                                isolated_pipe{i,1} = obj.pipe_relative{i,1};
%                                 new_isolated_pipe{i,1} = obj.pipe_relative{i,1};
                                mid_str = ['Isolated pipe',obj.pipe_relative{i,1},';'];
                                str_length = length(mid_str);
                                str2(str2_n:str2_n+str_length-1) = mid_str;
                                str2_n = str2_n+str_length;
                                the_close_pipe = isolated_pipe{i,1};
                                [~,the_pipe_segment_loc] = ismember(the_close_pipe,obj.pipe_id);
                                the_pipe_segment = obj.Pipe_flag(the_pipe_segment_loc);
                                the_segment_pipe_close = obj.Valve_segment(the_pipe_segment);
                                
                                for p = 1:numel(the_segment_pipe_close{1}) % 所处区域内管道均关闭
                                    id = libpointer('cstring',the_segment_pipe_close{1}{p,1});
                                    index =libpointer('int32Ptr',0);
                                    [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                                    code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,0);%管道id状态为关闭
                                    fprintf(fid_log_file,'隔离管道:%s\r\n',the_segment_pipe_close{1}{p,1} );
                                end
                                for j =1:numel(obj.pipe_relative{i,2})% 隔离的管道为当前管道相关联的破坏管道。
                                    id = libpointer('cstring',obj.pipe_relative{i,2}{1,j});
                                    fprintf(fid_log_file,'隔离管道:%s\r\n',obj.pipe_relative{i,2}{1,j} );
                                    index =libpointer('int32Ptr',0);
                                    [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                                    if code
                                        disp(num2str(code));
                                        keyboard
                                    end
                                    code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,0);%管道id状态为关闭
                                    if code
                                        disp(num2str(code));
                                        fprintf(fid_log_file,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                                        keyboard
                                    end
                                    code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,0);
                                    if code
                                        disp(num2str(code))
                                        fprintf(fid_log_file,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                                        keyboard
                                    end
                                end
                            case 2
                                %isolation
                                mid_str_1 = ['-Isolated-pipe',obj.pipe_relative{i,1},';'];
                                str_length = length(mid_str_1);
                                str3(str3_n:str3_n+str_length-1) = mid_str_1;
                                str3_n = str3_n+str_length;
                                try
                                new_isolated_pipe{i,1} = obj.pipe_relative{i,1};
                                the_open_pipe = new_isolated_pipe{i,1};
                                catch
                                    i
                                    keyboard
                                end
                                if ~isempty(the_open_pipe)
                                    [~,the_pipe_segment_loc] = ismember(the_open_pipe,obj.pipe_id);
                                    the_pipe_segment = obj.Pipe_flag(the_pipe_segment_loc);
                                    the_segment_pipe_close = obj.Valve_segment(the_pipe_segment);
                                    for p = 1:numel(the_segment_pipe_close{1}) % 所处区域内管道均开启
                                        id = libpointer('cstring',the_segment_pipe_close{1}{p,1});
                                        index =libpointer('int32Ptr',0);
                                        [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                                        code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,1);%管道id状态为开
                                        fprintf(fid_log_file,'开启管道:%s\r\n',the_segment_pipe_close{1}{p,1} );
                                    end
                                end
                                for j =1:numel(obj.pipe_relative{i,2})% 隔离的管道为当前管道相关联的破坏管道。
                                    id = libpointer('cstring',obj.pipe_relative{i,2}{1,j});
                                    fprintf(fid_log_file,'隔离管道:%s\r\n',obj.pipe_relative{i,2}{1,j} );
                                    index =libpointer('int32Ptr',0);
                                    [code,id,index]=calllib(obj.lib_name,'ENgetlinkindex',id,index);
                                    if code
                                        disp(num2str(code));
                                        keyboard
                                    end
                                    code=calllib(obj.lib_name,'ENsetlinkvalue',index,11,0);%管道id状态为关闭
                                    if code
                                        disp(num2str(code));
                                        fprintf(fid_log_file,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                                        keyboard
                                    end
                                    code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,0);
                                    if code
                                        disp(num2str(code));
                                        fprintf(fid_log_file,'隔离管道:%s出错,代码%s\r\n',id,num2str(code) );
                                        keyboard
                                    end
                                end
                                %reopen
                                isolated_pipe(cellfun(@isempty,isolated_pipe)) = [];
                                if ismember(obj.pipe_relative{i,1},isolated_pipe)
                                    mid_str_2 = ['Replaced pipe',obj.pipe_relative{i,1},';'];
                                else
                                    mid_str_2 = ['Repaired pipe',obj.pipe_relative{i,1},';'];
                                end
                                str_lenth = length(mid_str_2);
                                str3(str3_n:str3_n+str_lenth-1) = mid_str_2;
                                str3_n = str3_n+str_lenth;
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
                                    fprintf(fid_log_file,'reopen管道:%s出错,代码%s\r\n',id,num2str(code) );
                                    keyboard
                                end
                                code= calllib(obj.lib_name,'ENsetlinkvalue',index,4,1);
                                fprintf(fid_log_file,'reopen管道%s,\r\n',obj.pipe_relative{i,1});
                                if code
                                    disp(nem2str(code));
                                    fprintf(fid_log_file,'reopen管道:%s出错,代码%s\r\n',id,num2str(code) );
                                    keyboard
                                end
                        end
                        
                    end
                    str = [str1,deblank(str2),deblank(str3)];
                    fprintf(fid_log_file,'%s时刻,管道状态修改完毕\r\n',num2str(temp_t) );
                else
                    str = 'No action;';
                    fprintf(fid_log_file,'%s时刻,管道状态无需修改完毕\r\n',num2str(temp_t) );
                end
                if obj.export_inp == 1
                    inpfile_name = ['time',num2str(time_step_n),'.inp'];
                    err_out = calllib(obj.lib_name,'ENsaveinpfile',inpfile_name);
                    if err_out ~=0
                        keyboard
                    end
                end
                [errcode4,temp_t] = calllib(obj.lib_name,'ENrunH',temp_t);
                obj.ENrun_num = obj.ENrun_num +1;
                n_ENrun = n_ENrun +1;
                obj.calculate_code(time_step_n) = errcode4;
                if errcode4
                    %                     keyboard
                    %                     disp(num2str(errcode4));
                    fprintf(fid_log_file,'ENrunH出错,代码%s\r\n',num2str(errcode4) );
                    if errcode4 <100
                        %                         disp(num2str(errcode4))
                    else
                        keyboard
                    end
                end
                time_timeStep{time_step_n} = temp_t;
                [real_pre_chosen_node,cal_demand_chosen_node,req_demand_chosen_node]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.node_id);
                [~,cal_demand_chosen_reservoirs,~]=Get_chosen_node_value_EPANETx64PDD(obj.lib_name,obj.reservoirs_id);
                Pre{time_step_n} = real_pre_chosen_node;
                if obj.export_inp == 1
                    if errcode4 ~=0
                        node = 1:numel(cal_demand_chosen_node);
                        fig1 = Plot(node,cal_demand_chosen_node,node,req_demand_chosen_node);
                        fig1.XLabel = 'Node';
                        fig1.YLabel = 'Demand (LPS)';
                        fig1.Legend = {'cal_demand','req_demand'};
                        fig1.LegendBox = 'on';
                        fig1.export([obj.out_dir,num2str(time_step_n),'demand.png']);
                        fig1.delete
                        try
                            fig2 = Plot(node,real_pre_chosen_node);
                        catch
                            keyboard
                        end
                        fig2.XLabel = 'Node';
                        fig2.YLabel = 'Pressure (m)';
                        fig2.export([obj.out_dir,num2str(time_step_n),'pressure.png']);
                        fig2.delete
                    end
                end
                
                %                 Demand{time_step_n}=req_demand_chosen_node;
                cal_Demand{time_step_n}=cal_demand_chosen_node;%
                
                new_cal_demand_chosen_node = cal_demand_chosen_node;%计算结果，需要将异常的节点需水量进行调整
                new_cal_demand_chosen_node(cal_demand_chosen_node<0) = 0; %计算需水量为负值时，将其需水量调整为0；
                new_cal_demand_chosen_node(cal_demand_chosen_node>req_demand_chosen_node) = 0;%若计算需水量大于需水量，则调整为0；
                if time_step_n > 2 % 为了修复问题：系统供水满足率出现下降的点。增加一条判断。若节点需水量小于上一时刻的节点需水量，则采用上一时刻的节点需水量
                    previous_cal_demand_chosen_node = adjust_Demand{time_step_n-1};
                    loc = (new_cal_demand_chosen_node<previous_cal_demand_chosen_node);
                    new_cal_demand_chosen_node(loc) = previous_cal_demand_chosen_node(loc);
                end
                adjust_Demand{time_step_n} = new_cal_demand_chosen_node;
                system_serviceability_cell{time_step_n}= sum(new_cal_demand_chosen_node)/sum(req_demand_chosen_node);%采用调整后的计算需水量，求系统供水满意率
                node_serviceability_cell{time_step_n} =  cal_demand_chosen_node./req_demand_chosen_node;
                reservoirs_supply_cell{time_step_n} = cal_demand_chosen_reservoirs;
                activity_cell{time_step_n} = str;%记录每个时间步的行为
                leakage_water_mat(time_step_n) = sum( cal_demand_chosen_reservoirs)+sum(cal_demand_chosen_node);
                [errcode4,temp_tstep]=calllib(obj.lib_name,'ENnextH',temp_tstep);
            end
            fclose(fid_log_file);
            obj.errcode(6) = calllib(obj.lib_name,'ENclose');
            obj.activity = activity_cell;
            obj.system_serviceability = system_serviceability_cell;
            obj.node_demand_calculate = cal_Demand;
            obj.node_pressure_calculate = Pre;
            obj.time = time_timeStep;
            obj.node_serviceability = node_serviceability_cell;
            obj.reservoirs_supply = reservoirs_supply_cell;
            obj.damage_leakage.sum = leakage_water_mat;
            obj.adjust_demand = adjust_Demand;
            if obj.dispKeyWord ==1
                disp('Run_debug结束运行')
            end
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

