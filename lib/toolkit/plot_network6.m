%% 画管网模型示意图
% node_coodinate 节点坐标
% pipe_line 节点关系，连线
function plot_network6(net_data)
pipe_line=net_data{5,2}(:,1:3);
D=cell2mat(net_data{5,2}(:,5));
node_coodinate=net_data{23,2};
sum_pipe_num=numel(pipe_line(:,1));
node_x=cell2mat(node_coodinate(:,2));
node_y=cell2mat(node_coodinate(:,3));
figure
scatter(node_x,node_y,'k','filled')%画出节点
for i=1:sum_pipe_num
    node1_index=ismember(node_coodinate(:,1),pipe_line{i,2});
    node2_index=ismember(node_coodinate(:,1),pipe_line{i,3});
    temp_x1=node_x(node1_index);
    temp_y1=node_y(node1_index);
    temp_x2=node_x(node2_index);
    temp_y2=node_y(node2_index);
    H=line([temp_x1,temp_x2],[temp_y1,temp_y2]);
    if D(i)>=610
        set(H,'color','r')
    else
        set(H,'color','k')
    end
    hold on
end
end