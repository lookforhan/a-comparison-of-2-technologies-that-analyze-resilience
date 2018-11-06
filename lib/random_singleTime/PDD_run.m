function [pressure_PDD,demand_PDD]=PDD_run(MC_simulate_result_dir,inputdata,circulation_num,doa,...
    original_junction_num,junction_num,Hmin,Hdes,node_original_data,~)
output_inp=[MC_simulate_result_dir,'\damage_net','PPD','.inp'];%输出inp文件名称
output_rpt=[MC_simulate_result_dir,'\damage_net','PPD','.rpt'];%输出报告文件名称
output_out=[MC_simulate_result_dir,'\damage_net','PPD','.out'];%输出二进制文件名称
calllib('epanet2','ENopen',inputdata,output_rpt,output_out);%打开inputdata文件
C_mid=ones(junction_num,1);
HMIN=Hmin*C_mid;HDES=Hdes*C_mid;two=2*C_mid;
[~,bdemand]=Get(junction_num,1);%需水量
for n=1:circulation_num%确定循环次数
    calllib('epanet2','ENsolveH');% 运行水力计算
%     calllib('epanet2','ENsaveH');%保存
    %---------------检索计算结果
    [~,pre]=Get(junction_num,11);%压力
    [~,bdemand1]=Get(junction_num,1);%需水量
    bdemand2=bdemand;%bdemand2作为中间变量
    %----------%根据水压处理需水量
    bdemand2(pre<=Hmin)=0;
    [i2]=find(pre(:,1)>=Hmin&pre(:,1)<=Hdes);
    bdemand2(i2,1)=(bdemand1(i2,1)+bdemand(i2,1).*((pre(i2,1)-HMIN(i2,1))./(HDES(i2,1)-HMIN(i2,1))).^(1/2))./two(i2,1);
    error=abs(bdemand1-bdemand2)./bdemand1;
    b=max(error);
    if b<0.01
%         disp(['PDD满足收敛条件,迭代',num2str(n),'次'])
        break
    end
    %----------%将处理后需水量输入EPA
    for j=1:junction_num
        calllib('epanet2','ENsetnodevalue',j,1,bdemand2(j,1));
    end
end
% calllib('epanet2','ENsaveinpfile',output_inp);
% calllib('epanet2','ENsetreport','NODES ALL'); % 设置输出报告的格式
% calllib('epanet2','ENreport'); %输出计算报告
%     [~,out_pre]=Get(junction_num,11);%压力
%     [~,out_demand]=Get(junction_num,1);%需水量
%----指定节点压力和需水量-----------
node_id=node_original_data(:,1);
[out_pre,out_demand]=Get_chosen_node_value(original_junction_num,node_id);
%     ----------------------------------------
pressure_PDD=out_pre;
demand_PDD=out_demand;
calllib('epanet2','ENclose'); %关闭计算
end