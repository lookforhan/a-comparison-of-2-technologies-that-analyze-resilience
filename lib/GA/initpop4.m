% 2018-1-1����������ʼ��Ⱥ�а����ܵ�������
%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
% initpop.m�����Ĺ�����ʵ��Ⱥ��ĳ�ʼ����popsize��ʾȺ��Ĵ�С��chromlength��ʾȾɫ��ĳ���(��ֵ���ĳ���)��
% ���ȴ�Сȡ���ڱ����Ķ����Ʊ���ĳ���(�ڱ�����ȡ10λ)��
%�Ŵ��㷨�ӳ���
%Name: initpop.m
%��ʼ����Ⱥ
% pop=initpop2(20,{1;4;2;3;5})
function [pop_isolation_init]=initpop4(popsize,Pipe_isolation)
n_isolation = numel(Pipe_isolation);
priority_isolation=zeros(n_isolation,popsize);%��һ��Ϊ�ܵ�������
for i = 1:popsize
    priority_isolation(:,i) = randperm(n_isolation);
end
pop_isolation_init = Pipe_isolation(priority_isolation)';
% ���Ϊ����
% ÿһ��Ϊһ���޸���������
end