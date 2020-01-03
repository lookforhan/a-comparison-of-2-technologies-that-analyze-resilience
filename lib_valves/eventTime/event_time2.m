function [ Dp_Inspect_mat,Dp_Repair_mat ,Dp_Travel_mat] = event_time2( damage_pipe_info,net_data)
%event_time2 生成各个管道的隔离时间和修复时间
%   计算各个管道的破坏修复时间
%   关闭一个阀门的时间为15min
%   修复渗漏管道的时间为0.223*D^0.577
%   修复断开管道的时间为0.156*D^0.719
%
load('mod_segment.mat')
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
        Dp_travel(i,j) = 0;
%         Dp_travel(i,j)=triangular_distribution(distance(i,j)/80,distance(i,j)/25,distance(i,j)/40);
    end
end

for pipe_i=1:numel(BreakPipe_order)
    %     Dp_inspect(pipe_i)= triangular_distribution(0.5,1,0.5);%检查时间
    the_pipe = damage_pipe_info{5}{pipe_i};
     [~,the_pipe_segment_loc] = ismember(the_pipe,link.pipeID);
     the_pipe_segment = pipe_flag(the_pipe_segment_loc);
     the_segment_pipe_close = valve_pipe_segment(the_pipe_segment);
     
     pipe_loc_i = BreakPipe_order{pipe_i};
    D = net_data{5,2}{pipe_loc_i,5};
    if find(damage_pipe_info{3}==2)%判断是断开/泄露
        %                     Dp_repair(pipe_i)=triangular_distribution(120,240,168);%干路-断开;
        if numel(the_segment_pipe_close{1})==1
        valve_num=2;
        else 
            valve_num = numel(the_segment_pipe_close{1});
        end
        Dp_repair(pipe_i)=0.156*D^0.719;
    else%泄露
        %                     Dp_repair(pipe_i)=triangular_distribution(96,120,96);%干路-泄露;
        Dp_repair(pipe_i)=0.223*D^0.577;
        valve_num = 0;
    end
    Dp_inspect(pipe_i) = valve_num*0.25;
end
% Dp_Inspect_mat=Dp_inspect*3600;
Dp_Inspect_mat=Dp_inspect;
% Dp_Repair_mat=Dp_repair*3600;
Dp_Repair_mat=Dp_repair;
% Dp_Travel_mat=Dp_travel*3600;
Dp_Travel_mat=Dp_travel;
end

