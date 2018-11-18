% 2018-2-5；韩朝：增加画图：将韧性散点图、最优韧性以及平均韧性三合一。
% 2018-1-16;韩朝：增加输出F,system_L,system_serviceability,node2_serviceability
%2018-1-18;韩朝：增加加载和卸载动态链接库的命令，由于动态链接库本身的问题当多次调用后会出现不可预测的错误
% 2018-1-3;韩朝：关闭无用的输出
% 2018-1-1;韩朝：增加管道检查和关闭管道过程
%% 2017-12-19
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 为了梳理代码，将遗传算法中计算适应度函数部分代码整合
%% 输入
% BreakPipePriority，管道修复次序，优化变量
% RepairCrew,修复队伍编号
% BreakPipe_order,管道破坏信息存储顺序
% MC_i，蒙特卡罗模拟次数
% generation_i,优化代数次数
% individual_i,个体数
% original_junction_num，管网原始节点数目
% damage_pipe_info,管道破坏信息
% MC_simulate_result_dir，蒙特卡罗模拟结果存储文件夹
% individual_dir_i,个体计算结果文件夹
% EPA_format,inp水力模型文件格式
% node_original_data，管网节点原始数据
% circulation_num，PDD水力分析最大迭代次数
% doa,PDD水力计算精度
% Hmin,PDD水力计算最低水压
% Hdes,PDD水力计算满足水压
% node_original_dem,管网节点原始需水量
% system_original_L，管网管道运行原始长度
%% 输出
%Fitness 适应度函数
% BreakPipe_result,(nB,4), 记录：1破坏管道编号\2修复开始时间\3修复结束时间\4维修队伍编号
% RepairCrew_result,(RN,3),记录：1维修队伍编号\2维修了管道个数\3平均修复时间
% F,记录系统性态的时程变化
% system_L,记录管道工作长度的时程变化
% system_serviceability,记录系统供水满意率的时程变化
% node2_serviceability，
function [Fitness,BreakPipe_result,RepairCrew_result,F,system_L,system_serviceability,node_serviceability,node2_serviceability,node_calculate_dem,node_calculate_pre,timeStep_end]=fit3(BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat,...
    original_junction_num,damage_pipe_info,net_data,...
    MC_i,generation_i,individual_i,MC_simulate_result_dir,generation_dir_i,individual_dir_i,...
    EPA_format,node_original_data,circulation_num,doa,Hmin,Hdes,node_original_dem,system_original_L,...
    plot_keyword,pressure_cell,demand_cell)%评价种群个体适应度
n=numel(BreakPipePriority);
% BreakPipe_InspectPriority=BreakPipePriority(1:n/2);
% BreakPipe_RepairPriority=BreakPipePriority(n/2+1:end);
[BreakPipe_result,RepairCrew_result]=priorityList2schedule4(BreakPipePriority,RepairCrew,BreakPipe_order,...
    Dp_Inspect_mat,Dp_Repair_mat,Dp_Travel_mat);%根据修复次序生成时间表

PipeStatus=schedule2pipestatus2(BreakPipe_result);%根据时间表生成管道状态矩阵

if strcmpi(plot_keyword,'on')
    [newPipeStatus_1,ia,ic]=unique(PipeStatus','rows');
    newPipeStatus_2=[ia,newPipeStatus_1];
    newPipeStatus_3=sortrows(newPipeStatus_2);
    newPipeStatus_4=newPipeStatus_3;
    newPipeStatus=newPipeStatus_4';
    filename=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'_timeStep_','.txt'];
    dlmwrite(filename,newPipeStatus)
end
timeStep_end=numel(PipeStatus(1,:));%时间步数
node_calculate_pre=zeros(original_junction_num,timeStep_end);%节点每个时间步的压力
node_calculate_dem=zeros(original_junction_num,timeStep_end);%节点每个时间步的配水量
node_serviceability=zeros(original_junction_num,timeStep_end);%节点每个时间步的满足率
system_serviceability=zeros(1,timeStep_end);%系统每个时间步的满足率
node2_serviceability=zeros(1,timeStep_end);%重要节点每个时间步的满足率
system_L=zeros(1,timeStep_end);%系统运行管道长度比率
system_timeStep_L=zeros(1,timeStep_end);%系统每个时间步运行管道长度
% demand_cell=cell(1,timeStep_end);%PDD记录水量
% pressure_cell=cell(1,timeStep_end);%PDD记录水压
% MC_i=1;
for timeStep_i=1:timeStep_end
    %     disp(['第',num2str(MC_i),'模拟；','遗传第',num2str(generation_i),'代；','个体',num2str(individual_i),'；时间步',num2str(timeStep_i),'/',num2str(timeStep_end)])
    %     disp(['第',num2str(timeStep_i),'时间步开始'])
    
    if timeStep_i>1
        
        if all(PipeStatus(:,timeStep_i)==PipeStatus(:,timeStep_i-1))%如果相同
            node_calculate_dem(:,timeStep_i)=node_calculate_dem(:,timeStep_i-1);
            node_calculate_pre(:,timeStep_i)=node_calculate_pre(:,timeStep_i-1);
            node_serviceability(:,timeStep_i)=node_serviceability(:,timeStep_i-1);
            node2_serviceability(timeStep_i)=node2_serviceability(timeStep_i-1);
            system_serviceability(timeStep_i)=system_serviceability(timeStep_i-1);
            system_L(timeStep_i)=system_L(timeStep_i-1);
            %         disp('fit 无管道状态变化')
            continue
        end
    end
    PipeStatus_timeStep=PipeStatus(:,timeStep_i);
    [outdata]=timeStepNet(PipeStatus_timeStep,damage_pipe_info,net_data);%输出当前时间步的管道状态管网信息。
    %                 disp('fit ok')
    if strcmpi(plot_keyword,'on')
        output_net_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'_timeStep_',num2str(timeStep_i),'.inp'];%第i次模拟输出管网inp文件
        output_rpt_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'_timeStep_',num2str(timeStep_i),'.rpt'];%第i次模拟输出管网rpt文件
        output_out_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'_timeStep_',num2str(timeStep_i),'.out'];%第i次模拟输出管网out文件
    else
        output_net_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'.inp'];%第i次模拟输出管网inp文件
        output_rpt_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'.rpt'];%第i次模拟输出管网rpt文件
        output_out_filename_n=[individual_dir_i,'\damage_net_',num2str(MC_i),'_generation_',num2str(generation_i),'individual',num2str(individual_i),'.out'];%第i次模拟输出管网out文件
    end
    t_W=Write_Inpfile4(net_data,EPA_format,outdata,output_net_filename_n);% 写入新管网inp
    %     if t_W==0%判断Write_Inpfile结果
    %         %         disp(['写入inp文件完成！时间步为',num2str(timeStep_i)]);
    %     else
    %         %         disp('写入inp文件出错！');
    %         return
    %     end
    %% 进行地震破坏管网水力模型的平差计算；
    inputdata=output_net_filename_n;%输入文件名称
    out_rpt_filename=output_rpt_filename_n;%输出报告文件名称
    out_out_filename=output_out_filename_n;%输出二进制文件名称
    t1=calllib('epanet2','ENopen',inputdata,out_rpt_filename,out_out_filename);
    if t1~=0
        keyboard
    end
    t2=calllib('epanet2','ENsolveH');% 运行水力计算
    if t2~=0&&t2~=6
        %         t2
        
        unloadlibrary epanet2;%卸载epanet2.dll
        loadlibrary('epanet2.dll','epanet2.h'); %加载EPA动态链接库
        calllib('epanet2','ENopen',inputdata,out_rpt_filename,out_out_filename);
        calllib('epanet2','ENsolveH');% 运行水力计算
        %         keyboard
    end
    calllib('epanet2','ENsaveH');%保存
    calllib('epanet2','ENsetreport','NODES ALL'); % 设置输出报告的格式
    calllib('epanet2','ENreport'); %输出计算报告
    count=libpointer('int32Ptr',0);%指针参数--计数，中间变量
    [~,count_node]=calllib('epanet2','ENgetcount',0,count);%全部节点个数
    [~,count_tank]=calllib('epanet2','ENgetcount',1,count);%水池和水厂个数
    junction_num=count_node-count_tank;%用户节点个数
    %----所有节点压力和需水量-----------
    [~,all_node_pressure]=Get(junction_num,11);%节点压力,
    %     [~,all_node_demand]=Get(junction_num,1);%需水量
    %----指定节点压力和需水量-----------
    [out_pre,out_demand]=Get_chosen_node_value(original_junction_num,node_original_data);
    %     ----------------------------------------
    pressure_cell{MC_i,timeStep_i}=out_pre;
    demand_cell{MC_i,timeStep_i}=out_demand;
    calllib('epanet2','ENclose'); %关闭计算
    negative_node=find(all_node_pressure<10, 1);%负压节点
    if ~isempty(negative_node)
        %         disp('存在负压');
        % PDD调整需水量后水力平差
        [pressure_PDD,demand_PDD]=PDD_run(MC_simulate_result_dir,inputdata,circulation_num,doa,...
            original_junction_num,junction_num,Hmin,Hdes,node_original_data,MC_i);
        pressure_cell{MC_i,timeStep_i}=pressure_PDD;
        demand_cell{MC_i,timeStep_i}=demand_PDD;
    else
        t=1;
        %         disp('无负压')
    end
    node_calculate_pre(:,timeStep_i)=pressure_cell{MC_i,timeStep_i};
    node_calculate_dem(:,timeStep_i)=demand_cell{MC_i,timeStep_i};
    node_serviceability(:,timeStep_i)=node_calculate_dem(:,timeStep_i)./node_original_dem;
    system_serviceability(timeStep_i)=sum(node_calculate_dem(:,timeStep_i))/sum(node_original_dem);%全部节点
    node_2=[2;4];
    node2_serviceability(timeStep_i)=sum(node_calculate_dem(node_2,timeStep_i))/sum(node_original_dem(node_2));%特定节点
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

F_resiliencd=sum(F);%需要
Fitness=F_resiliencd/timeStep_end;
% Fitness=F_resiliencd;
save([individual_dir_i,'\fi2.mat'])
% Fitness=F_resiliencd;
%% 作图
%%
% if strcmpi(plot_keyword,'on')
if false
    t=plot_fit_plot(individual_dir_i,...
    system_serviceability_plot,...第1张
    node2_serviceability,...第2张
    system_L_plot,...第3张
    F,...第4张
    BreakPipe_result,RepairCrew...第5张
    );%
    
    
    % 绘制管道状态与节点供水满意率的空间分布图------------------------------------
    % 首先：看要绘制多少？每改变一次管道状态，就要绘制一张图。
    node_coodinate=net_data{23,2};%节点id,x坐标，y坐标
    pipe_line=net_data{5,2}(:,1:3);%管道id,节点1id，节点2id.
    node_id=net_data{2,2}(:,1);%节点id
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
            plot_network3(individual_dir_i,['管网状态',num2str(time1((ij-1)*4+il)),'（hour）'],node_coodinate,pipe_line,node_id,node_serviceability(:,time1((ij-1)*4+il)),pipe_status,time1((ij-1)*4+il))
        end
        colorbar('southoutside','units','centimeters','position',[1,1.1,12.5,0.2])
        saveas(fig3,[individual_dir_i,'\','管网状态','（hour）',num2str(ij)],'epsc');
        saveas(fig3,[individual_dir_i,'\','管网状态','（hour）',num2str(ij)],'meta');
        saveas(fig3,[individual_dir_i,'\','管网状态','（hour）',num2str(ij)],'fig');
    end
end

end