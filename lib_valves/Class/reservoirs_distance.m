function new_order=reservoirs_distance(order,net_data)

n=numel(order);
if n==1
    new_order=order;
else
    distance=zeros(n,1);%��ʼ���������
    pipe_coordinate=pipe2coordinate(order,net_data);%�ܵ��е�����
    node_coordinate=net_data{23,2};
    reservoirs_id=net_data{3,2}(:,1);
    [~,lia]=ismember(reservoirs_id,node_coordinate(:,1));
    reservoirs_coordinate=cell2mat(node_coordinate(lia,2:3));%ˮԴ�������
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
    new_order2(:,1)=[];%ɾ����һ��
    new_order=num2cell(new_order2);
end
end
function coordinate=pipe2coordinate(pipe_loc,net_data)

pipe_num=numel(pipe_loc);%ȷ����Ҫ����Ĺܵ�����
coordinate=cell(pipe_num,3);
pipe_info=net_data{5,2}(pipe_loc,:);%�ҹܵ��ı��\�ڵ�\���ȵ���Ϣ
for i=1:pipe_num
    N1=pipe_info{i,2};%�ҹܵ�����ʼ�ڵ���
    N2=pipe_info{i,3};%�ҹܵ�����ֹ�ڵ���
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