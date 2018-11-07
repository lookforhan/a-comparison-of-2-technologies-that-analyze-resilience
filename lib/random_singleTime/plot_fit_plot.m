function t=plot_fit_plot(individual_dir_i,...
    system_serviceability_plot,...��1��
    node2_serviceability,...��2��
    system_L_plot,...��3��
    F,...��4��
    BreakPipe_result,RepairCrew...��5��
    )%
t=0;
%% ��1��
f1=figure('visible','off');
plot(system_serviceability_plot)
grid on
set(gca,'XScale','log');
%                 axis([1,10,0,1])
title('fit2-��ˮ������ˮ�����ʻָ�����');
xlabel('time(hour)')
ylabel('serviceability');
% legend('serviceability(t)')
saveas(f1,[individual_dir_i,'\01serviceability'],'meta');
%% ��2��
f11=figure('visible','off');
plot([1,node2_serviceability])
grid on
set(gca,'XScale','log');
%                 axis([1,10,0,1])
title('fit2-��ˮ������ˮ�����ʻָ�����');
xlabel('time(hour)')
ylabel('serviceability');
% legend('serviceability(t)')
saveas(f11,[individual_dir_i,'\05serviceability'],'meta');
%% ��3��
f2=figure('visible','off');
plot(system_L_plot)
grid on
set(gca,'XScale','log');
title('fi2-��ˮ��������');
xlabel('time(hour)')
ylabel('length_net');
% legend('length_net(t)')
saveas(f2,[individual_dir_i,'\02length'],'meta');
%% ��4��
f3=figure('visible','off');
grid on
set(gca,'XScale','log');
F_plot=[1,F];
plot(F_plot);
title('fit2-��ˮ����F(T)�ָ�����');
xlabel('time(hour)')
ylabel('F');
% legend('F(t)')
saveas(f3,[individual_dir_i,'\03fit2-��ˮ����F(T)�ָ�����'],'meta');
% ------------------------------------
%% ��5��
task=pipe2task(BreakPipe_result);%�۲�������Ϊ
n_lin=task(:,1);
[~,locb]=ismember(n_lin,RepairCrew);
n_lin2=cell2mat(task(:,2:4));
a=[locb,n_lin2];
f4=figure('visible','off');%����ͼ
w=0.5;       %�������
set(gcf,'color','w');
for ii=1:size(a,1)
    x=a(ii,[3 3 4 4]);
    y=a(ii,1)+[-w/2 w/2 w/2 -w/2];
    switch a(ii,2)
        case 0
            color='red';
        case 1
            color='green';
        case 2
            color='blue';
    end
    p=patch('xdata',x,'ydata',y,'facecolor',color,'edgecolor',color);
    %     p=patch('xdata',x,'ydata',y,'facecolor','none','edgecolor','k');
    %     text(a(ii,3)+0.5,a(ii,1),num2str(a(ii,2)));
end
xlabel('processing time(s)');
ylabel('RepairCrew');
grid on
set(gca,'XScale','log');
% axis([0 20 0 10]);
set(gca,'Box','on');

nR=numel(RepairCrew);
set(gca,'YTick',0:nR+1);
set(gca,'YTickLabel',{'';num2str((1:nR)','RC%d');''});
title('fit2-ganttchart');
% set(gca,'FontSize',20);
saveas(f4,[individual_dir_i,'\04ganttchart'],'meta');

% plot_network3(dir,name,node_coodinate,pipe_line,node_id,node_serviceability,pipe_status)


end