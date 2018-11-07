function [ t ] = GPM2LPS( in_file,out_file )
%GPM2LPS �����Ƶ�λ��INP�ļ�ת��Ϊ���Ƶ�λ��INP�ļ�
%   �ȶ���in_file�ļ�
%   ͨ��dll���벢д�ļ�
%   ͨ��matlab�����ļ�
%   ͨ����λת������������
%   д���ļ���
%   ������1GPM = 0.063LPS
%   ���ȣ�1m = 3.2808399ft
%   �ܾ�:1in = 25.4mm
%   ���ʣ�1kW = 1.3596216ps
%

t = libisloaded('epanet2');
if t == 0
    loadlibrary('epanet2.dll','epanet2.h');
end
calllib('epanet2','ENopen',in_file,'tem_t.rpt','t.out');
calllib('epanet2','ENsaveinpfile','tem_new.inp');
flag=0;
[~,flag] = calllib('epanet2','ENgetflowunits',flag);
calllib('epanet2','ENclose');
unloadlibrary epanet2
if flag ~=1
    disp('��λ����')
    t = 1;
    flag
    return
end
fid = fopen('EPA_format2.txt','r');
EPA_format = textscan(fid,'%q%q%q','delimiter',';');
fclose(fid);
[~,net_data]=Read_File_dll_inp4('tem_new.inp',EPA_format);%��ȡˮ��ģ��inp�ļ������ݣ�
out_data = net_data;
% �ڵ�߳�ת����ft��->(m)
node_elevation_in = cell2mat(net_data{2,2}(:,2));
node_elevation_out = node_elevation_in *0.3048;
out_data{2,2}(:,2) = [];
out_data{2,2} =[out_data{2,2},num2cell(node_elevation_out)];
%------------------------------
% �ܵ�
% �ܵ�ֱ��
link_diameter_in = cell2mat(net_data{5,2}(:,5));
link_diameter_out =link_diameter_in * 25.4;
out_data{5,2}(:,5) = [];
out_data{5,2} =[out_data{5,2}(:,1:4),num2cell(link_diameter_out),out_data{5,2}(:,5:end)];
% �ܵ�����
link_length_in = cell2mat(net_data{5,2}(:,4));
link_length_out = link_length_in *0.3048;
out_data{5,2}(:,4) = [];
out_data{5,2} = [out_data{5,2}(:,1:3),num2cell(link_length_out),out_data{5,2}(:,4:end)];
% ˮ��ˮͷ
reservoirs_head_in = cell2mat(net_data{3,2}(:,2));
reservoirs_head_out = reservoirs_head_in *0.3048;
out_data{3,2}(:,2) = [];
out_data{3,2} = [out_data{3,2}(:,1),num2cell(reservoirs_head_out)];
% ˮ��
tank_in1 = cell2mat(net_data{4,2}(:,2:5));
tank_out1 = tank_in1*0.3048;
tank_in2 = cell2mat(net_data{4,2}(:,6));
tank_out2 = tank_in2*0.0283168;
out_data{4,2}(:,2:6) =[];
out_data{4,2} = [out_data{4,2}(:,1),num2cell(tank_out1),num2cell(tank_out2),out_data{4,2}(:,1)];
outdata=[];
% ��ˮ��
demand_in = cell2mat(net_data{15,2}(:,2));
demand_out = demand_in*0.063;
out_data{15,2}(:,2)=[];
out_data{15,2} = [out_data{15,2}(:,1),num2cell(demand_out),out_data{15,2}(:,2)];
% ���õ�λ
out_data{20,2}{1,2} = 'LPS';
t=Write_Inpfile5(out_data,EPA_format,outdata,out_file);
% ˮ�����ߵ�λ����
% curve_in_x = out_data{9,2}()
end

