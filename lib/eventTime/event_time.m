function [ Dp_Inspect_mat,Dp_Repair_mat ,Dp_Travel_mat] = event_time( damage_pipe_info,net_data)
%event_time 此处显示有关此函数的摘要
%   计算各个管道的破坏修复时间
BreakPipe_order=num2cell(damage_pipe_info{1});
coordinate=pipe2coordinate(damage_pipe_info{1},net_data);%破坏管道中点坐标
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
    Dp_inspect(pipe_i)= triangular_distribution(0.5,1,0.5);%检查时间
    if net_data{5,2}{pipe_i,5}>=610%判断干路/支路
        if find(damage_pipe_info{3}==2)%判断是断开/泄露
            %                     Dp_repair(pipe_i)=triangular_distribution(120,240,168);%干路-断开;
            Dp_repair(pipe_i)=triangular_distribution(120,240,168);
        else%泄露
            %                     Dp_repair(pipe_i)=triangular_distribution(96,120,96);%干路-泄露;
            Dp_repair(pipe_i)=triangular_distribution(96,120,96);
        end
    else %支路
        if find(damage_pipe_info{3}==2)%判断是断开/泄露
            Dp_repair(pipe_i)=triangular_distribution(4,12,6);%支路-断开;
        else%泄露
            Dp_repair(pipe_i)=triangular_distribution(3,6,4);%支路-泄露;
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

