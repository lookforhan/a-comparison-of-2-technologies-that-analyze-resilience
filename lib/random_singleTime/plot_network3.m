% ���ӹ��ܣ���ʾ�ͽڵ�ƽ����ˮ������
%% ������ģ��ʾ��ͼ

function plot_network3(dir,name,node_coodinate,pipe_line,node_id,node_serviceability,pipe_status,time)
% node_coodinate �ڵ�����
% pipe_line �ڵ��ϵ������
% node_id �ڵ�id
% node_serviceability �ڵ㹩ˮ������
% pipe_status �ܵ�״̬0��ã�1�رգ�2�ƻ�
%------------------------------------------------
FontSize_1=8;
FontSize_2=6;
sz_j=40;
sz_r=60;
LW=2;
[loc1,lia1]=ismember(node_coodinate(:,1),node_id);%
% [loc2,lia2]=ismember(node_id,node_coodinate(:,1));
% [loc2,lia2]=ismember('5',node_coodinate(:,1));
%�ҳ�ˮԴ�ڵ㣬��loc==0
% lia_r=node_coodinate(loc1==0,:);
%���ڵ�id���������˳������
% lia_j=node_id(lia1(loc1~=0));
node_serviceability_linshi=node_serviceability(lia1(loc1~=0));
%------------------------------------------------
sum_pipe_num=numel(pipe_line(:,1));
node_x=cell2mat(node_coodinate(:,2));
node_y=cell2mat(node_coodinate(:,3));
% fig1=figure('visible','on');
% set(gcf,'units','centimeters','position',[0,0,9,7.5]);
% set(gca,'units','centimeters','position',[1.5,1.5,7,4.5],'box','on','FontSize',FontSize_2)
set(gca,'FontSize',FontSize_2);
title(['time=',num2str(time),'(hours)'],'FontSize',FontSize_1,'units','n','position',[0.5,1.05,0])
% axis([min(node_x),max(node_x),min(node_y),max(node_y)])
caxis([0,1])
axis equal
axis tight
axis off
hold on
% legend('�ڵ�','ˮԴ')

for i=1:sum_pipe_num
    node1_index=ismember(node_coodinate(:,1),pipe_line{i,2});
    node2_index=ismember(node_coodinate(:,1),pipe_line{i,3});
    temp_x1=node_x(node1_index);
    temp_y1=node_y(node1_index);
    temp_x2=node_x(node2_index);
    temp_y2=node_y(node2_index);
    H=line([temp_x1,temp_x2],[temp_y1,temp_y2],'LineWidth',LW);
    switch pipe_status(i)
        case 0
            set(H,'color','k')%������Ϊ��ɫ
        case 1
            set(H,'color','b')%������Ϊ��ɫ
        case 2
            set(H,'color','r')%������Ϊ��ɫ
    end
end
scatter(node_x(lia1(loc1~=0)),node_y(lia1(loc1~=0)),sz_j,node_serviceability_linshi,'filled','o')%�����ڵ�
scatter(node_x(lia1(loc1~=0)),node_y(lia1(loc1~=0)),sz_j,'k','o')%�����ڵ�����
% scatter(node_x(lia1(loc1~=0)),node_y(lia1(loc1~=0)),sz_j,'MarkerFaceColor',node_serviceability_linshi,'MarkerEdgeColor','k','o')%�����ڵ�
scatter(node_x(loc1==0),node_y(loc1==0),sz_r,'k','filled','s')%����ˮԴ
hold off
%     saveas(fig1,[dir,'\',name],'meta');
%     saveas(fig1,[dir,'\',name],'fig');
end