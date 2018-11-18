function [ Q_after ] = pdd_HBW( Q_before,Q_req,node_pre,Hmin,Hdes,Q_adjust_coefficent )
%pdd_HBW PDD方法调节需水量
%   此处显示详细说明
% Hmin=0;%PDD模型Hmin节点最小压力水头(单位m)
% Hdes=10;%PDD模型Hdes节点需求压力水头(单位m);
% Q_adjust_coefficent=0.3; %PDD相邻两迭代步的节点基础需水量调整步长的调整系数,为确保收敛，一般不超过0.5；
junction_num = numel(Q_before);
C_mid=ones(junction_num,1);
HMIN=Hmin*C_mid;HDES=Hdes*C_mid;
Q_after=Q_before;
loc_1=node_pre<=Hmin;
Q_after(loc_1)=(1-Q_adjust_coefficent)*Q_before(loc_1)+Q_adjust_coefficent*0;
loc_2=(node_pre(:,1)>Hmin&node_pre(:,1)<Hdes);
Q_after(loc_2)=(1-Q_adjust_coefficent)*Q_before(loc_2)+Q_adjust_coefficent*(Q_req(loc_2).*((node_pre(loc_2)-HMIN(loc_2))./(HDES(loc_2)-HMIN(loc_2))).^(1/2));
end

