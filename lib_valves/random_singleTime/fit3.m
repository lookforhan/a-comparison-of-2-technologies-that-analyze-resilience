% 2018-2-5�����������ӻ�ͼ��������ɢ��ͼ�����������Լ�ƽ����������һ��
% 2018-1-16;�������������F,system_L,system_serviceability,node2_serviceability
%2018-1-18;���������Ӽ��غ�ж�ض�̬���ӿ��������ڶ�̬���ӿⱾ������⵱��ε��ú����ֲ���Ԥ��Ĵ���
% 2018-1-3;�������ر����õ����
% 2018-1-1;���������ӹܵ����͹رչܵ�����
%% 2017-12-19
%% ���� hanzhao@emails.bjut.edu.cn
%% Ϊ��������룬���Ŵ��㷨�м�����Ӧ�Ⱥ������ִ�������
%% ����
% BreakPipePriority���ܵ��޸������Ż�����
% RepairCrew,�޸�������
% BreakPipe_order,�ܵ��ƻ���Ϣ�洢˳��
% MC_i�����ؿ���ģ�����
% generation_i,�Ż���������
% individual_i,������
% original_junction_num������ԭʼ�ڵ���Ŀ
% damage_pipe_info,�ܵ��ƻ���Ϣ
% MC_simulate_result_dir�����ؿ���ģ�����洢�ļ���
% individual_dir_i,����������ļ���
% EPA_format,inpˮ��ģ���ļ���ʽ
% node_original_data�������ڵ�ԭʼ����
% circulation_num��PDDˮ����������������
% doa,PDDˮ�����㾫��
% Hmin,PDDˮ���������ˮѹ
% Hdes,PDDˮ����������ˮѹ
% node_original_dem,�����ڵ�ԭʼ��ˮ��
% system_original_L�������ܵ�����ԭʼ����
%% ���
%Fitness ��Ӧ�Ⱥ���
% BreakPipe_result,(nB,4), ��¼��1�ƻ��ܵ����\2�޸���ʼʱ��\3�޸�����ʱ��\4ά�޶�����
% RepairCrew_result,(RN,3),��¼��1ά�޶�����\2ά���˹ܵ�����\3ƽ���޸�ʱ��
% F,��¼ϵͳ��̬��ʱ�̱仯
% system_L,��¼�ܵ��������ȵ�ʱ�̱仯
% system_serviceability,��¼ϵͳ��ˮ�����ʵ�ʱ�̱仯
% node2_serviceability��
function [Fitness,BreakPipe_result,RepairCrew_result,F,system_L,system_serviceability,node_serviceability,node2_serviceability,node_calculate_dem,node_calculate_pre,timeStep_end]=fit3(BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    original_junction_num,damage_pipe_info,net_data,...
    MC_i,generation_i,individual_i,MC_simulate_result_dir,generation_dir_i,individual_dir_i,...
    EPA_format,node_original_data,circulation_num,doa,Hmin,Hdes,node_original_dem,system_original_L,...
    plot_keyword,pressure_cell,demand_cell)%������Ⱥ������Ӧ��
n=numel(BreakPipePriority);
% BreakPipe_InspectPriority=BreakPipePriority(1:n/2);
% BreakPipe_RepairPriority=BreakPipePriority(n/2+1:end);
[BreakPipe_result,RepairCrew_result]=priorityList2schedule4(BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat);%�����޸���������ʱ���

PipeStatus=schedule2pipestatus2(BreakPipe_result);%����ʱ������ɹܵ�״̬����

if strcmpi(plot_keyword,'on')
    [newPipeStatus_1,ia,ic]=unique(PipeStatus','rows');
    newPipeStatus_2=[ia,newPipeStatus_1];
    newPipeStatus_3=sortrows(newPipeStatus_2);
    newPipeStatus_4=newPipeStatus_3;
    newPipeStatus=newPipeStatus_4';
    filename=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'_timeStep_','.txt'];
    dlmwrite(filename,newPipeStatus)
end
timeStep_end=numel(PipeStatus(1,:));%ʱ�䲽��
node_calculate_pre=zeros(original_junction_num,timeStep_end);%�ڵ�ÿ��ʱ�䲽��ѹ��
node_calculate_dem=zeros(original_junction_num,timeStep_end);%�ڵ�ÿ��ʱ�䲽����ˮ��
node_serviceability=zeros(original_junction_num,timeStep_end);%�ڵ�ÿ��ʱ�䲽��������
system_serviceability=zeros(1,timeStep_end);%ϵͳÿ��ʱ�䲽��������
node2_serviceability=zeros(1,timeStep_end);%��Ҫ�ڵ�ÿ��ʱ�䲽��������
system_L=zeros(1,timeStep_end);%ϵͳ���йܵ����ȱ���
system_timeStep_L=zeros(1,timeStep_end);%ϵͳÿ��ʱ�䲽���йܵ�����
% demand_cell=cell(1,timeStep_end);%PDD��¼ˮ��
% pressure_cell=cell(1,timeStep_end);%PDD��¼ˮѹ
% MC_i=1;
for timeStep_i=1:timeStep_end
    %     disp(['��',num2str(MC_i),'ģ�⣻','�Ŵ���',num2str(generation_i),'����','����',num2str(individual_i),'��ʱ�䲽',num2str(timeStep_i),'/',num2str(timeStep_end)])
    %     disp(['��',num2str(timeStep_i),'ʱ�䲽��ʼ'])
    
    if timeStep_i>1
        
        if all(PipeStatus(:,timeStep_i)==PipeStatus(:,timeStep_i-1))%�����ͬ
            node_calculate_dem(:,timeStep_i)=node_calculate_dem(:,timeStep_i-1);
            node_calculate_pre(:,timeStep_i)=node_calculate_pre(:,timeStep_i-1);
            node_serviceability(:,timeStep_i)=node_serviceability(:,timeStep_i-1);
            node2_serviceability(timeStep_i)=node2_serviceability(timeStep_i-1);
            system_serviceability(timeStep_i)=system_serviceability(timeStep_i-1);
            system_L(timeStep_i)=system_L(timeStep_i-1);
            %         disp('fit �޹ܵ�״̬�仯')
            continue
        end
    end
    PipeStatus_timeStep=PipeStatus(:,timeStep_i);
    [outdata]=timeStepNet(PipeStatus_timeStep,damage_pipe_info,net_data);%�����ǰʱ�䲽�Ĺܵ�״̬������Ϣ��
    %                 disp('fit ok')
    if strcmpi(plot_keyword,'on')
        output_net_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'_timeStep_',num2str(timeStep_i),'.inp'];%��i��ģ���������inp�ļ�
        output_rpt_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'_timeStep_',num2str(timeStep_i),'.rpt'];%��i��ģ���������rpt�ļ�
        output_out_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'_timeStep_',num2str(timeStep_i),'.out'];%��i��ģ���������out�ļ�
    else
        output_net_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'.inp'];%��i��ģ���������inp�ļ�
        output_rpt_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'.rpt'];%��i��ģ���������rpt�ļ�
        output_out_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'.out'];%��i��ģ���������out�ļ�
    end
    t_W=Write_Inpfile4(net_data,EPA_format,outdata,output_net_filename_n);% д���¹���inp
    %     if t_W==0%�ж�Write_Inpfile���
    %         %         disp(['д��inp�ļ���ɣ�ʱ�䲽Ϊ',num2str(timeStep_i)]);
    %     else
    %         %         disp('д��inp�ļ�����');
    %         return
    %     end
    %% ���е����ƻ�����ˮ��ģ�͵�ƽ����㣻
    inputdata=output_net_filename_n;%�����ļ�����
    out_rpt_filename=output_rpt_filename_n;%��������ļ�����
    out_out_filename=output_out_filename_n;%����������ļ�����
    t1=calllib('epanet2','ENopen',inputdata,out_rpt_filename,out_out_filename);
    if t1~=0
        keyboard
    end
    t2=calllib('epanet2','ENsolveH');% ����ˮ������
    if t2~=0&&t2~=6
        %         t2
        
        unloadlibrary epanet2;%ж��epanet2.dll
        loadlibrary('epanet2.dll','epanet2.h'); %����EPA��̬���ӿ�
        calllib('epanet2','ENopen',inputdata,out_rpt_filename,out_out_filename);
        calllib('epanet2','ENsolveH');% ����ˮ������
        %         keyboard
    end
    calllib('epanet2','ENsaveH');%����
    calllib('epanet2','ENsetreport','NODES ALL'); % �����������ĸ�ʽ
    calllib('epanet2','ENreport'); %������㱨��
    count=libpointer('int32Ptr',0);%ָ�����--�������м����
    [~,count_node]=calllib('epanet2','ENgetcount',0,count);%ȫ���ڵ����
    [~,count_tank]=calllib('epanet2','ENgetcount',1,count);%ˮ�غ�ˮ������
    junction_num=count_node-count_tank;%�û��ڵ����
    %----���нڵ�ѹ������ˮ��-----------
    [~,all_node_pressure]=Get(junction_num,11);%�ڵ�ѹ��,
    %     [~,all_node_demand]=Get(junction_num,1);%��ˮ��
    %----ָ���ڵ�ѹ������ˮ��-----------
    [out_pre,out_demand]=Get_chosen_node_value(original_junction_num,node_original_data);
    %     ----------------------------------------
    pressure_cell{MC_i,timeStep_i}=out_pre;
    demand_cell{MC_i,timeStep_i}=out_demand;
    calllib('epanet2','ENclose'); %�رռ���
    negative_node=find(all_node_pressure<10, 1);%��ѹ�ڵ�
    if ~isempty(negative_node)
        %         disp('���ڸ�ѹ');
        % PDD������ˮ����ˮ��ƽ��
        [pressure_PDD,demand_PDD]=PDD_run(MC_simulate_result_dir,inputdata,circulation_num,doa,...
            original_junction_num,junction_num,Hmin,Hdes,node_original_data,MC_i);
        pressure_cell{MC_i,timeStep_i}=pressure_PDD;
        demand_cell{MC_i,timeStep_i}=demand_PDD;
    else
        t=1;
        %         disp('�޸�ѹ')
    end
    node_calculate_pre(:,timeStep_i)=pressure_cell{MC_i,timeStep_i};
    node_calculate_dem(:,timeStep_i)=demand_cell{MC_i,timeStep_i};
    node_serviceability(:,timeStep_i)=node_calculate_dem(:,timeStep_i)./node_original_dem;
    system_serviceability(timeStep_i)=sum(node_calculate_dem(:,timeStep_i))/sum(node_original_dem);%ȫ���ڵ�
    node_2=[2;4];
    node2_serviceability(timeStep_i)=sum(node_calculate_dem(node_2,timeStep_i))/sum(node_original_dem(node_2));%�ض��ڵ�
    pipe_id=net_data{5,2}(:,1);
    [~,lia_pipe]=ismember(pipe_id,outdata{1}(:,1));
    [~,~,V]=find(lia_pipe);
    system_timeStep_L(timeStep_i)=sum(cell2mat(outdata{1}(V,4)));
    system_L(timeStep_i)=system_timeStep_L(timeStep_i)/system_original_L;
    
end


w1=0.5;
w2=0.5;
system_serviceability_plot=[1,system_serviceability];
system_L_plot=[1,system_L];
F=w1*system_serviceability+w2*system_L;

F_resiliencd=sum(F);%��Ҫ
Fitness=F_resiliencd/timeStep_end;
% Fitness=F_resiliencd;
save([individual_dir_i,'\fi2.mat'])
% Fitness=F_resiliencd;
%% ��ͼ
%%
% if strcmpi(plot_keyword,'on')
if false
    t=plot_fit_plot(individual_dir_i,...
    system_serviceability_plot,...��1��
    node2_serviceability,...��2��
    system_L_plot,...��3��
    F,...��4��
    BreakPipe_result,RepairCrew...��5��
    );%
    
    
    % ���ƹܵ�״̬��ڵ㹩ˮ�����ʵĿռ�ֲ�ͼ------------------------------------
    % ���ȣ���Ҫ���ƶ��٣�ÿ�ı�һ�ιܵ�״̬����Ҫ����һ��ͼ��
    node_coodinate=net_data{23,2};%�ڵ�id,x���꣬y����
    pipe_line=net_data{5,2}(:,1:3);%�ܵ�id,�ڵ�1id���ڵ�2id.
    node_id=net_data{2,2}(:,1);%�ڵ�id
    pipe_status=zeros(numel(net_data{5,2}(:,1)),1);
    time1=newPipeStatus(1,:);
    % [loc,lia]=ismember(,pipe_line(:,1))
    
    num_pic=numel(newPipeStatus(1,:));
    n_f=2;
    m_f=2;
    position_f=[1,5,6,4.5;7.5,5,6,4.5;1,1,6,4.5;7.5,1,6,4.5];
    l_f=ceil(num_pic/4);
    for ij=1:l_f
        fig3=figure('visible','off');
        figure(fig3)
        set(gcf,'units','centimeters','position',[0,0,14.5,10]);
        for il=1:4
            if (ij-1)*4+il>num_pic
                break
            end
            subplot(n_f,m_f,il)
            set(gca,'units','centimeters','position',position_f(il,:));
            pipe_status(damage_pipe_info{1})=PipeStatus(:,time1((ij-1)*4+il));
            plot_network3(individual_dir_i,['����״̬',num2str(time1((ij-1)*4+il)),'��hour��'],node_coodinate,pipe_line,node_id,node_serviceability(:,time1((ij-1)*4+il)),pipe_status,time1((ij-1)*4+il))
        end
        colorbar('southoutside','units','centimeters','position',[1,1.1,12.5,0.2])
        saveas(fig3,[individual_dir_i,'\','����״̬','��hour��',num2str(ij)],'epsc');
        saveas(fig3,[individual_dir_i,'\','����״̬','��hour��',num2str(ij)],'meta');
        saveas(fig3,[individual_dir_i,'\','����״̬','��hour��',num2str(ij)],'fig');
    end
end

end