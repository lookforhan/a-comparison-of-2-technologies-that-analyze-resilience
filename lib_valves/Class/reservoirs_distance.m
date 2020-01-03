function new_order=reservoirs_distance(order,net_data)

n=numel(order);
if n==1
    new_order=order;
else
    distance=zeros(n,1);%初始化距离矩阵
    pipe_coordinate=pipe2coordinate(order,net_data);%管道中点坐标
    node_coordinate=net_data{23,2};
    reservoirs_id=net_data{3,2}(:,1);
    [~,lia]=ismember(reservoirs_id,node_coordinate(:,1));
    reservoirs_coordinate=cell2mat(node_coordinate(lia,2:3));%水源点的坐标
    d1=zeros(numel(reservoirs_id),1);
    for i=1:n
        x=pipe_coordinate{i,2};
        y=pipe_coordinate{i,3};
        
        for j=1:numel(reservoirs_id)
        d1(j)=sqrt((x-reservoirs_coordinate(j,1)^2+(y-reservoirs_coordinate(j,2))^2));
        end
        distance(i)=min(d1);
    end
    new_order1=[distance,order];
    new_order2=sortrows(new_order1);
    new_order2(:,1)=[];%删除第一列
    new_order=num2cell(new_order2);
end
end
function coordinate=pipe2coordinate(pipe_loc,net_data)

pipe_num=numel(pipe_loc);%确定需要计算的管道个数
coordinate=cell(pipe_num,3);
pipe_info=net_data{5,2}(pipe_loc,:);%找管道的编号\节点\长度等信息
for i=1:pipe_num
    N1=pipe_info{i,2};%找管道的起始节点编号
    N2=pipe_info{i,3};%找管道的终止节点编号
    N1_loc=ismember(net_data{23,2}(:,1),N1);
    N1_x=net_data{23,2}{N1_loc,2};
    N1_y=net_data{23,2}{N1_loc,3};
    N2_loc=ismember(net_data{23,2}(:,1),N2);
    N2_x=net_data{23,2}{N2_loc,2};
    N2_y=net_data{23,2}{N2_loc,3};
    coordinate{i,1}=pipe_info{i,1};
    coordinate{i,2}=(N1_x+N2_x)/2;
   coordinate{i,3}=(N1_y+N2_y)/2; 
end


end