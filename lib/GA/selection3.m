% ���������Ӧ�������Ӧ��ֵnew_fitvalue
% �޸�ѡ��ʽ
% %% hanzhao
% �ο����ף�
% [1]������,����,���ĳ�.��MATLABʵ���Ŵ��㷨����[J].�����Ӧ���о�,2001(08):80-82
% [2] ����, ������. �Ŵ��㷨ԭ��Ӧ��[M]. ������ҵ������, 1999.(3.3��)
% �ص㣺��ѡ�������в������ű�����Ժͱ���ѡ�����ϵ�˼·
% ��Ӣ���岻�����Ŵ�����
% ���evo_gen�в��������ź�������
%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%�Ŵ��㷨�ӳ���
%Name: selection.m
%ѡ����
%{
fitvalue_0={28;24;22;20;18}
Fitvalue={97.500;95;92.500;90;87.500}
pop{1}=1
pop{2}=2
pop{3}=3
pop{4}=4
pop{5}=5
% pop{1}={52;11;42;7;60;34;8;58;52;60;7;8;58;34;42;11}
% pop{2}={60;42;52;8;34;7;58;11;7;11;58;8;34;42;52;60}
% pop{3}={58;42;52;8;34;60;7;11;34;52;7;8;42;11;58;60}
% pop{4}={52;60;34;7;42;11;58;8;8;58;11;42;60;34;7;52}
% pop{5}={52;58;8;42;7;34;60;11;7;60;58;11;42;34;8;52}
[newpop,new_fitvalue,best_indiv,max_fitness]=selection(pop,Fitvalue,fitvalue_0)
%}
function [newpop,best_indiv,second_best_indiv]=selection3(pop,Fitvalue)
popsize=numel(pop(:,1));
fitvalue=cell2mat(Fitvalue);
% fitvalue2=cell2mat(fitvalue_0);
%% ���ű������
% newpop=cell(n,1);
[~,index1]=max(fitvalue);%���Ÿ�����Ӧ��ֵ
fitvalue(index1)=0;
best_indiv=pop(index1,:);
[~,index2]=max(fitvalue);%��������Ӧ��ֵ
second_best_indiv=pop(index2,:);
index=1:popsize;index(index1)=0;index(index2)=0;%ɾ�������ź͵ڶ��Ÿ����λ��
index=nonzeros(index);%ɾ�������ź͵ڶ��Ÿ����λ��
evo_pop=pop(index,:);%ɾ�����ź͵ڶ��Ÿ����λ��
evo_fitvalue=fitvalue(index);%ɾ�����ź͵ڶ��Ÿ����λ��
% evo_fitvalue1=fitvalue2(index);%ɾ�������ź����������Ӧ��
evo_popsize=popsize-2;%ʣ�µĸ�����
%% ���̶ģ�����ѡ�񷨣�
totalfit=sum(evo_fitvalue); %����Ӧֵ֮��
Ppop=evo_fitvalue/totalfit; %�������屻ѡ��ĸ���
Ppop_sum=cumsum(Ppop); %�� fitvalue=[1 2 3 4]���� cumsum(fitvalue)=[1 3 6 10] 
r=rand(1,evo_popsize);
loc_selected=[sum(Ppop_sum*ones(1,evo_popsize)<ones(evo_popsize,1)*r)+1]';%ѡ��
% new_fitvalue=evo_fitvalue1(loc_selected);%ѡ����Ⱥ��Ӧ����Ӧ��ֵ
newpop=evo_pop(loc_selected,:);%ѡ�����Ⱥ
end