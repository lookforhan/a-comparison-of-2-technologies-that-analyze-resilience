function [pressure_PDD,demand_PDD]=PDD_run(MC_simulate_result_dir,inputdata,circulation_num,doa,...
    original_junction_num,junction_num,Hmin,Hdes,node_original_data,~)
output_inp=[MC_simulate_result_dir,'\damage_net','PPD','.inp'];%���inp�ļ�����
output_rpt=[MC_simulate_result_dir,'\damage_net','PPD','.rpt'];%��������ļ�����
output_out=[MC_simulate_result_dir,'\damage_net','PPD','.out'];%����������ļ�����
calllib('epanet2','ENopen',inputdata,output_rpt,output_out);%��inputdata�ļ�
C_mid=ones(junction_num,1);
HMIN=Hmin*C_mid;HDES=Hdes*C_mid;two=2*C_mid;
[~,bdemand]=Get(junction_num,1);%��ˮ��
for n=1:circulation_num%ȷ��ѭ������
    calllib('epanet2','ENsolveH');% ����ˮ������
%     calllib('epanet2','ENsaveH');%����
    %---------------����������
    [~,pre]=Get(junction_num,11);%ѹ��
    [~,bdemand1]=Get(junction_num,1);%��ˮ��
    bdemand2=bdemand;%bdemand2��Ϊ�м����
    %----------%����ˮѹ������ˮ��
    bdemand2(pre<=Hmin)=0;
    [i2]=find(pre(:,1)>=Hmin&pre(:,1)<=Hdes);
    bdemand2(i2,1)=(bdemand1(i2,1)+bdemand(i2,1).*((pre(i2,1)-HMIN(i2,1))./(HDES(i2,1)-HMIN(i2,1))).^(1/2))./two(i2,1);
    error=abs(bdemand1-bdemand2)./bdemand1;
    b=max(error);
    if b<0.01
%         disp(['PDD������������,����',num2str(n),'��'])
        break
    end
    %----------%���������ˮ������EPA
    for j=1:junction_num
        calllib('epanet2','ENsetnodevalue',j,1,bdemand2(j,1));
    end
end
% calllib('epanet2','ENsaveinpfile',output_inp);
% calllib('epanet2','ENsetreport','NODES ALL'); % �����������ĸ�ʽ
% calllib('epanet2','ENreport'); %������㱨��
%     [~,out_pre]=Get(junction_num,11);%ѹ��
%     [~,out_demand]=Get(junction_num,1);%��ˮ��
%----ָ���ڵ�ѹ������ˮ��-----------
node_id=node_original_data(:,1);
[out_pre,out_demand]=Get_chosen_node_value(original_junction_num,node_id);
%     ----------------------------------------
pressure_PDD=out_pre;
demand_PDD=out_demand;
calllib('epanet2','ENclose'); %�رռ���
end