%% 2017-12-15
%% ���� hanzhao@emails.bjut.edu.cn
%% ���ܣ����ݹܵ�״̬�����ı�ܵ��ƻ���Ϣ
%% ����
% PipeStatus, �ܵ�״̬����
% damage_pipe_info, �ܵ��ƻ���Ϣ
%% ���
% damage_pipe_info_after, �ƻ��ܵ�����Ϣ
% close_pipe_info, �رչܵ��ı��
function [damage_pipe_info_after,close_pipe_info]=timeStepdamage(PipeStatus,damage_pipe_info)
% ��ʼ������
M1=damage_pipe_info{1};
M2=damage_pipe_info{2};
M3=damage_pipe_info{3};
M4=damage_pipe_info{4};
M5=damage_pipe_info{5};
M6=damage_pipe_info{6};
M7=damage_pipe_info{7};
%
H1=M1(PipeStatus~=0);%ɾ���ܵ����
K1=M1(PipeStatus==2);%�ƻ��ܵ����
K2=M2(PipeStatus==2,:);%�ƻ��ܵ���Ϣ
K3=M3(PipeStatus==2,:);%�ƻ��ܵ���Ϣ
K4=M4(PipeStatus==2,:);%�ƻ��ܵ���Ϣ
K5=M5(PipeStatus==2,:);%�ƻ��ܵ���Ϣ
K6=M6(PipeStatus==2,:);%�ƻ��ܵ���Ϣ
K7=M7(PipeStatus==2,:);%�ƻ��ܵ���Ϣ
damage_pipe_info_after=[{K1},{K2},{K3},{K4},{K5},{K6},{K7}];
%��1�ƻ����ߵ�λ�ú�(����)��2�����ƻ���֮ǰ�ĳ��ȱ���(����)��3�ƻ�����ƻ�����(����)��4��©�ƻ������ɢ��ϵ��(����)
close_pipe_info=H1;
end