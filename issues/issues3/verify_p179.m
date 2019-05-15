% verify_p179
% 本脚本的目的是生成新的INP文件，并找到导致节点需水量异常的原因
% 猜测原因是某些关闭造成的。
clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
root = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\';
try
    libfunctions (lib_name);
catch
loadlibrary([root,'materials\',lib_name],[root,'materials\',h_name]);
end
try
    load  EPA_F
catch
    path([root,'lib\readNet'],path);%
    path([root,'lib\damageNet'],path);%
    path([root,'lib\EPS'],path);%
    path([root,'lib\getValue'],path);%
    path([root,'lib\eventTime'],path);% ?
    path([root,'lib\random'],path);%
    path([root,'lib\ga'],path);%
    path([root,'lib\Class'],path);% 类
    path([root,'lib\toolkit'],path);%\
    path('C:\Users\hc042\Documents\GitHub\PlotPub\lib',path);
    %     path('..\lib\random_singleTime',path);%
    load  EPA_F
end
origin_net_file =[root,'materials\MOD\','MOD_5_mean.inp'];
[t3_1,net_data_origin] = read_net2_EPANETx64PDD(origin_net_file,EPA_format);% from 'readNet\'
node_id = net_data_origin{2,2}(:,1);

origin_file = 'time1.inp';
% the_chosen_pipe_id = {'addP-179-2';'addP-179-1';'addP-157-1';'addP-157-2' };
% the_chosen_pipe_id = {'addP-157-1';'addP-157-2' };
the_chosen_pipe_id = {'addP-179-2';'addP-179-1' };
err_get_pipe_index = zeros(numel(the_chosen_pipe_id),1);
err_close_pipe = zeros(numel(the_chosen_pipe_id),1);
err_open_1 = calllib(lib_name,'ENopen',origin_file,[origin_file(1:end-3),'rpt'],'');
pipe_index_i=libpointer('int32Ptr',0);
for i = 1:numel(the_chosen_pipe_id)
    [err_get_pipe_index(i),the_chosen_pipe_id{i,1},pipe_index_i]=calllib(lib_name,'ENgetlinkindex',the_chosen_pipe_id{i,1},pipe_index_i);%指定节点id的index
    err_close_pipe(i) = calllib(lib_name,'ENsetlinkvalue',pipe_index_i,11,0);
    err_close_pipe(i) = calllib(lib_name,'ENsetlinkvalue',pipe_index_i,4,0);
end
new_inp = [origin_file(1:end-4),'-close','.inp'];
err_set_time_param = calllib(lib_name,'ENsettimeparam',0,0);
err_save_inp = calllib(lib_name,'ENsaveinpfile',new_inp);

err_close_1 = calllib(lib_name,'ENclose');
toc
err_open_2 = calllib(lib_name,'ENopen',new_inp,[new_inp(1:end-3),'rpt'],'');
err_solveH = calllib(lib_name,'ENsolveH');
[pre,calculate_demand,demand]=Get_chosen_node_value_EPANETx64PDD(lib_name,node_id);
err_close_2 = calllib(lib_name,'ENclose');
 t = plot_3_fig(net_data_origin,calculate_demand,demand,pre);
% plot
function t = plot_3_fig(net_data_origin,calculate_demand,demand,pre)
net = Plot_net(net_data_origin);

% 
demand_init = demand;
demand_dll_cal = calculate_demand;%计算供水量
demand_man_cal = zeros(numel(net_data_origin{15,2}(:,2)),1);%手工计算的需水量
pressure = pre;%计算水压
for i = 1:numel(net_data_origin{15,2}(:,2))
    if pressure(i) >=20
        demand_man_cal(i) = demand_init(i);
    else
        if pressure(i) <= 0
            demand_man_cal(i) = 0;
        else
            demand_man_cal(i) = demand_init(i)*sqrt(pressure(i)/20);
        end
    end
end
demand_diff = demand_dll_cal-demand_man_cal;

net.Plot_basic
fig1 = net.Fig_basic;
net.Fig_basic.Visible = 'off';
net.Fig_basic.CurrentAxes.Visible = 'off';
net.Fig_basic.Children.Title.Visible = 'on';
net.Fig_basic.Children.Title.String = 'Wagner模型计算需水量相差大于0.01节点分布';
node_no_zeros = find(abs(demand_diff) >0.01);
node_no_zeros_id = net_data_origin{2,2}(node_no_zeros,1);
for i = 1:numel(node_no_zeros)
    index = ismember(net_data_origin{23,2}(:,1),node_no_zeros_id(i));
    net.Node(index).Handle.MarkerFaceColor  = 'g';
    net.Node(index).Handle.SizeData = 20;
end
print(fig1,'c:\Users\hc042\Desktop\不一致节点分布','-dpng');
close 1
%
Node = 1:numel(calculate_demand);

fig2 = Plot(Node,calculate_demand,Node,demand_man_cal);
fig2.XLabel = 'Node';
fig2.YLabel = 'Demand (LPS)';
fig2.Legend = {'calculated by epanetx64pdd.dll','calculated by Wagner equation'};
fig2.LegendBox = 'on';
fig2.export('node_demand.png')
close 1
fig3 = Plot(Node,pre);
fig3.XLabel = 'Node';
fig3.YLabel = 'Pressure (m)';
fig3.export('node_pressure.png')
close 1

t = 0;
end