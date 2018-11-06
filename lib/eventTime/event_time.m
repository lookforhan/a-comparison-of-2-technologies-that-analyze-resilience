function [ Dp_Inspect_mat,Dp_Repair_mat ,Dp_Travel_mat] = event_time( damage_pipe_info,net_data)
%event_time �˴���ʾ�йش˺�����ժҪ
%   ��������ܵ����ƻ��޸�ʱ��
BreakPipe_order=num2cell(damage_pipe_info{1});
coordinate=pipe2coordinate(damage_pipe_info{1},net_data);%�ƻ��ܵ��е�����
pipe_n=numel(BreakPipe_order);
Dp_inspect=zeros(pipe_n,1) ;
Dp_repair=zeros(pipe_n,1) ;
Dp_travel=zeros(pipe_n,pipe_n) ;
distance=zeros(pipe_n,pipe_n) ;
for i=1:pipe_n
    for j=1:pipe_n
        distance(i,j)=((coordinate{i,2}-coordinate{j,2})^2+(coordinate{i,3}-coordinate{j,3})^2)^(0.5);
        Dp_travel(i,j)=triangular_distribution(distance(i,j)/80,distance(i,j)/25,distance(i,j)/40);
    end
end

for pipe_i=1:numel(BreakPipe_order)
    Dp_inspect(pipe_i)= triangular_distribution(0.5,1,0.5);%���ʱ��
    if net_data{5,2}{pipe_i,5}>=610%�жϸ�·/֧·
        if find(damage_pipe_info{3}==2)%�ж��ǶϿ�/й¶
            %                     Dp_repair(pipe_i)=triangular_distribution(120,240,168);%��·-�Ͽ�;
            Dp_repair(pipe_i)=triangular_distribution(120,240,168);
        else%й¶
            %                     Dp_repair(pipe_i)=triangular_distribution(96,120,96);%��·-й¶;
            Dp_repair(pipe_i)=triangular_distribution(96,120,96);
        end
    else %֧·
        if find(damage_pipe_info{3}==2)%�ж��ǶϿ�/й¶
            Dp_repair(pipe_i)=triangular_distribution(4,12,6);%֧·-�Ͽ�;
        else%й¶
            Dp_repair(pipe_i)=triangular_distribution(3,6,4);%֧·-й¶;
        end
    end
end
% Dp_Inspect_mat=Dp_inspect*3600;
Dp_Inspect_mat=Dp_inspect;
% Dp_Repair_mat=Dp_repair*3600;
Dp_Repair_mat=Dp_repair;
% Dp_Travel_mat=Dp_travel*3600;
Dp_Travel_mat=Dp_travel;
end

