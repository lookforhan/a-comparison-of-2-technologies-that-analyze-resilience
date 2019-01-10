classdef Schedule < handle
    %Schedule �������ת��Ϊʱ���
    %   �˴���ʾ��ϸ˵��
    %   Active_result,BreakPipe_resultΪpriorityList2schedule9.m���������
    
    properties % input
        active_schedule
        pipe_schedule
        pipe_origin % ������Ϣ�еĹܵ�˳��
        crew_origin % �޸����鼯��
    end
    properties(SetAccess = private) % �м����
        time_schedule_crew_pipeId % ʱ���ÿ�������޸��Ĺܵ�
        time_schedule_crew_activeType % ʱ���ÿ�������޸��Ļ����
        time_schedule_pipeStatus %ʱ���ÿ���ܵ���״̬��ʱ��仯
        time_schedule_pipeStatusChange %ʱ����ܵ�״̬�仯��ʱ��
    end
    properties(Dependent,SetAccess = private)
        end_time % ʱ��������ʱ��
        damage_pipe_id % �ܵ���id
    end
    properties(SetAccess = private) % ���
        schedule_table_crew_activeType %
        schedule_table_crew_pipeID
        schedule_table_pipe_status
        schedule_table_pipe_status_change
        schedule_table1
        schedule_table2
    end
    methods
        function obj = Schedule(Active_result,BreakPipe_result)
            obj.active_schedule = Active_result;
            obj.pipe_schedule = BreakPipe_result;
        end
        function Run(obj)
            obj.PipeStatus
            obj.CrewStatus
            VariableNames_pipe = obj.damage_pipe_id';
            VariableNames_crew = obj.crew_origin';
            time = (0:1:obj.end_time)';
            time_table = array2table(time,'VariableNames',{'TIME'});
            obj.schedule_table_pipe_status = array2table(obj.time_schedule_pipeStatus,'VariableNames',VariableNames_pipe);
            obj.schedule_table_pipe_status_change = array2table(obj.time_schedule_pipeStatusChange,'VariableNames',VariableNames_pipe);
            obj.schedule_table_crew_pipeID = cell2table(obj.time_schedule_crew_pipeId,'VariableNames',VariableNames_crew);
            obj.schedule_table_crew_activeType = cell2table(obj.time_schedule_crew_activeType,'VariableNames',VariableNames_crew);
            obj.schedule_table1 = [time_table,obj.schedule_table_crew_pipeID,obj.schedule_table_pipe_status];
            obj.schedule_table2 = [time_table,obj.schedule_table_crew_activeType,obj.schedule_table_pipe_status_change];
        end
        function PipeStatus(obj)
            n_isolation = sum((cell2mat(obj.pipe_schedule(:,6))==1));
            BreakPipe_InspectResult=obj.pipe_schedule(1:n_isolation,:);
            BreakPipe_RepairResult=obj.pipe_schedule(n_isolation+1:end,:);
            n_repairation=numel(BreakPipe_RepairResult(:,1));%�ƻ��ܵ�����
            PipeStatus_original=2*ones(n_repairation,1);%�ܵ���ʼ״̬Ϊ�ƻ���
            PipeStatusChange_original = zeros(n_repairation,1);
            endTime=ceil(max(cell2mat(BreakPipe_RepairResult(:,4))));%�����޸����ʱ��Ϊʱ�䲽��ֹ
            PipeStatus_1=2*ones(n_repairation,endTime);
            PipeStatusChange = zeros(n_repairation,endTime);
            Pipe_id = sort(cell2mat(BreakPipe_RepairResult(:,1)));
            time_1 = zeros(n_repairation,1);%�������ʱ��
            time_2 = zeros(n_repairation,1);%�޸���ʼʱ��
            time_3 = zeros(n_repairation,1);%�޸�����ʱ��
            for i_isolation = 1: n_isolation
                node_id = BreakPipe_InspectResult{i_isolation,1};
                [~,locb] = ismember(node_id,Pipe_id);
                time_1(locb)=ceil(BreakPipe_InspectResult{i_isolation,4});
            end
            for i_replacement= 1:n_repairation
                node_id = BreakPipe_RepairResult{i_replacement,1};
                [~,locb] = ismember(node_id,Pipe_id);
                time_2(locb)=ceil(BreakPipe_RepairResult{i_replacement,3});
                time_3(locb)=ceil(BreakPipe_RepairResult{i_replacement,4});
            end
            for i = 1:n_repairation
                if time_1(i)==0
                else
                    PipeStatus_1(i,time_1(i):time_3(i)-1) = 1;%����,�޸�ʱ�ܵ�״̬��Ϊ����
                    PipeStatusChange(i,time_1(i)) =1;
                end
                PipeStatus_1(i,time_3(i):end)=0;
                PipeStatusChange(i,time_3(i)) =2;
            end
            PipeStatus=[PipeStatus_original,PipeStatus_1];
            PipeStatusChange=[PipeStatusChange_original,PipeStatusChange];
            obj.time_schedule_pipeStatus = PipeStatus';
            obj.time_schedule_pipeStatusChange = PipeStatusChange';
        end
        function CrewStatus(obj)
            obj.active_schedule;
            obj.crew_origin;
            end_Time = obj.end_time+1;%��һ��Ϊ0ʱ�̣�����
            %             time = (0:1:end_time)';
            n_active = numel(obj.active_schedule(:,1));
            crew_schedule_pipeId = cell(end_Time,numel(obj.crew_origin));
            crew_schedule_activeType = cell(end_Time,numel(obj.crew_origin));
            for i = 2:n_active
                try
                    [~,loc_crew] = ismember(obj.active_schedule(i,1),obj.crew_origin);
                catch
                    keyboard
                end
                begin_loc = ceil(cell2mat(obj.active_schedule(i,2)))+1;%��һ��Ϊ0ʱ�̣�
                stop_loc = ceil(cell2mat(obj.active_schedule(i,3)))+1;%��һ��Ϊ0ʱ��
                crew_schedule_activeType(begin_loc:stop_loc,loc_crew) = obj.active_schedule(i,5);
                crew_schedule_pipeId(begin_loc:stop_loc,loc_crew) = obj.pipe_origin(obj.active_schedule{i,4});
                obj.time_schedule_crew_pipeId = crew_schedule_pipeId;
                obj.time_schedule_crew_activeType = crew_schedule_activeType;
            end
        end
    end
    methods
        function end_time = get.end_time(obj)
            end_time = ceil(max(cell2mat(obj.active_schedule(2:end,3))));
        end
        function damage_pipe_id = get.damage_pipe_id(obj)
            n_isolation = sum((cell2mat(obj.pipe_schedule(:,6))==1));
            BreakPipe_RepairResult=obj.pipe_schedule(n_isolation+1:end,:);
            pipe_loc = sort(cell2mat(BreakPipe_RepairResult(:,1)));
            damage_pipe_origin_id = obj.pipe_origin(pipe_loc);
            damage_pipe_id = cell(numel(damage_pipe_origin_id),1);
            for i = 1:numel(damage_pipe_origin_id)
                damage_pipe_id{i} = ['dp_',damage_pipe_origin_id{i}];
            end
        end
    end
end

