function [ Q_after ] = pdd_HBW( Q_before,Q_req,node_pre,Hmin,Hdes,Q_adjust_coefficent )
%pdd_HBW PDD����������ˮ��
%   �˴���ʾ��ϸ˵��
% Hmin=0;%PDDģ��Hmin�ڵ���Сѹ��ˮͷ(��λm)
% Hdes=10;%PDDģ��Hdes�ڵ�����ѹ��ˮͷ(��λm);
% Q_adjust_coefficent=0.3; %PDD�������������Ľڵ������ˮ�����������ĵ���ϵ��,Ϊȷ��������һ�㲻����0.5��
junction_num = numel(Q_before);
C_mid=ones(junction_num,1);
HMIN=Hmin*C_mid;HDES=Hdes*C_mid;
Q_after=Q_before;
loc_1=node_pre<=Hmin;
Q_after(loc_1)=(1-Q_adjust_coefficent)*Q_before(loc_1)+Q_adjust_coefficent*0;
loc_2=(node_pre(:,1)>Hmin&node_pre(:,1)<Hdes);
Q_after(loc_2)=(1-Q_adjust_coefficent)*Q_before(loc_2)+Q_adjust_coefficent*(Q_req(loc_2).*((node_pre(loc_2)-HMIN(loc_2))./(HDES(loc_2)-HMIN(loc_2))).^(1/2));
end

