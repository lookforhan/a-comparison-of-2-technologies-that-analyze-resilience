%% 2017-12-26
%% hanzhao@emails.bjut.edu.cn
%% ���ݹܵ��ż���ܵ��е������
% ���룺
% pipe_num����Ĺܵ��ž���
% net_data������Ϣ
% ���
% coordinate �ܵ��е��x,y����
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