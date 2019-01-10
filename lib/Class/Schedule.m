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
    properties % �м����
        time_schedule_crew
        time_schedule_pipe
    end
    methods
        function obj = Schedule(Active_result,BreakPipe_result)
            obj.active_schedule = Active_result;
            obj.pipe_schedule = BreakPipe_result;
        end
        function PipeStatus(obj)
            BreakPipe_result = obj.pipe_schedule;
            n_isolation = sum((cell2mat(obj.pipe_schedule(:,6))==1));
            BreakPipe_InspectResult=obj.pipe_schedule(1:n_isolation,:);
            BreakPipe_RepairResult=obj.pipe_schedule(n_isolation+1:end,:);
            n_repairation=numel(BreakPipe_RepairResult(:,1));%�ƻ��ܵ�����
            PipeStatus_original=2*ones(n_repairation,1);%�ܵ���ʼ״̬Ϊ�ƻ���
            %             PipeStatusChange_original = zeros(n_repairation,1);
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
            %             PipeStatusChange=[PipeStatusChange_original,PipeStatusChange];
            obj.time_schedule_pipe = PipeStatus';
        end
        function CrewStatus(obj)
            obj.active_schedule;
            obj.crew_origin
            end_time = ceil(max(cell2mat(obj.active_schedule(2:end,3))));
            time = (0:1:end_time)';
            n_active = numel(obj.active_schedule(:,1))
            crew_schedule_pipeId = cell(end_time,numel(obj.crew_origin));
            crew_schedule_activeType = cell(end_time,numel(obj.crew_origin));
            for i = 2:n_active-1
                try
                    [~,loc_crew] = ismember(obj.active_schedule(i,1),obj.crew_origin);
                catch
                    keyboard
                end
                begin_loc = ceil(cell2mat(obj.active_schedule(i,2)));
                stop_loc = ceil(cell2mat(obj.active_schedule(i,3)));
                crew_schedule_activeType(begin_loc:stop_loc,loc_crew) = obj.active_schedule(i,5);
                crew_schedule_pipeId(begin_loc:stop_loc,loc_crew) = obj.active_schedule(i,4);
            end
        end
    end
    
end

