clear;clc;close all;tic;
lib_name = 'EPANETx64PDD';
h_name = 'toolkit.h';
object_file1 = 'time1.inp';
object_file2 = 'time2.inp';
object_file3 = 'time3.inp';
object_file4 = 'time4.inp';
object_file = object_file3;


fid = 1;
root = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\';
loadlibrary(['..\..\materials\',lib_name],['..\..\materials\',h_name]);
origin_file =[root,'materials\MOD\','MOD_5_mean.inp'];
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
[t3_1,net_data_origin] = read_net2_EPANETx64PDD(origin_file,EPA_format);% from 'readNet\'
if t3_1
    keyboard
else
end

[data_origin] = get_node_value(origin_file,lib_name);
% [data_object] = get_node_value(object_file,lib_name);
err1 = calllib(lib_name,'ENopen',object_file,'test_obj.rpt','');
value1 = libpointer('doublePtr',0);
[err3,value1] = calllib(lib_name,'ENgetoption',0,value1);
% value2 = libpointer('longPtr',0);
[err4] = calllib(lib_name,'ENsettimeparam',0,0);
% node_set_zeros = {'221';'12'};
node_set_zeros = {'221'};
node_set_value = zeros(numel(node_set_zeros),1);
% node_set_value =3.3
[err5] = Set_chosen_node_value_EPANETx64PDD(lib_name,node_set_zeros,1,node_set_value);
node_id = net_data_origin{2,2}(:,1);
code=calllib(lib_name,'ENsolveH');
if code ==2
    disp('code ==2')
end
[pre,calculate_demand,demand]=Get_chosen_node_value_EPANETx64PDD(lib_name,node_id);
err2 = calllib(lib_name,'ENclose');
toc
%
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
%
Node = 1:numel(node_id);

fig2 = Plot(Node,calculate_demand,Node,demand_man_cal);
fig2.XLabel = 'Node';
fig2.YLabel = 'Demand (LPS)';
fig2.Legend = {'calculated by epanetx64pdd.dll','calculated by Wagner equation'};
fig2.LegendBox = 'on';
fig2.export('node_demand.png')
fig3 = Plot(Node,pre);
fig3.XLabel = 'Node';
fig3.YLabel = 'Pressure (m)';
fig3.export('node_pressure.png')


demand_init(221)
demand(221)
pre(12)
demand_dll_cal(221)
% net_data_origin{15,2}{12,2};


