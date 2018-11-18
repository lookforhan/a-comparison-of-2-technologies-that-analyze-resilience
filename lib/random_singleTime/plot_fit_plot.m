function t=plot_fit_plot(individual_dir_i,...
    system_serviceability_plot,...第1张
    node2_serviceability,...第2张
    system_L_plot,...第3张
    F,...第4张
    BreakPipe_result,RepairCrew...第5张
    )%
t=0;
%% 第1张
f1=figure('visible','off');
plot(system_serviceability_plot)
grid on
set(gca,'XScale','log');
%                 axis([1,10,0,1])
title('fit2-供水管网供水满足率恢复曲线');
xlabel('time(hour)')
ylabel('serviceability');
% legend('serviceability(t)')
saveas(f1,[individual_dir_i,'\01serviceability'],'meta');
%% 第2张
f11=figure('visible','off');
plot([1,node2_serviceability])
grid on
set(gca,'XScale','log');
%                 axis([1,10,0,1])
title('fit2-供水管网供水满足率恢复曲线');
xlabel('time(hour)')
ylabel('serviceability');
% legend('serviceability(t)')
saveas(f11,[individual_dir_i,'\05serviceability'],'meta');
%% 第3张
f2=figure('visible','off');
plot(system_L_plot)
grid on
set(gca,'XScale','log');
title('fi2-供水管网长度');
xlabel('time(hour)')
ylabel('length_net');
% legend('length_net(t)')
saveas(f2,[individual_dir_i,'\02length'],'meta');
%% 第4张
f3=figure('visible','off');
grid on
set(gca,'XScale','log');
F_plot=[1,F];
plot(F_plot);
title('fit2-供水管网F(T)恢复曲线');
xlabel('time(hour)')
ylabel('F');
% legend('F(t)')
saveas(f3,[individual_dir_i,'\03fit2-供水管网F(T)恢复曲线'],'meta');
% ------------------------------------
%% 第5张
task=pipe2task(BreakPipe_result);%观察队伍的行为
n_lin=task(:,1);
[~,locb]=ismember(n_lin,RepairCrew);
n_lin2=cell2mat(task(:,2:4));
a=[locb,n_lin2];
f4=figure('visible','off');%甘特图
w=0.5;       %横条宽度
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