%% ���޸ģ�29-Jan-2018;hanzhao;�������޸�����ϲ����������� 
% =================================================================
% ���������Ӧ�������Ӧ��ֵ��
% ����������û�иı����ĵ���Ӧ��ֵ
% 2018-1-1,�������޸ĺ����������ӹܵ���鲿�ֵĵĽ���
% ��һ���汾�������������pop������ֻ�йܵ��޸�����
% �����汾���������pop�����ǰһ���ǹܵ������򣬺�һ�����ܵ��޸�����
% ����������ǰһ�룬������򽻲棬�޸����򲻱�
% ���������ں�һ�룬�������򲻱䣬�޸����򽻲�
% �����������м䣬�򽻻��޸�����
%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%�Ŵ��㷨�ӳ���
% ����(crossover)��Ⱥ���е�ÿ������֮�䶼��һ���ĸ��� pc ���棬����������Ӹ����ַ�����ĳһλ��
% ��һ�������ȷ������ʼ���ཻ����������������������еĻ�����������顣���磬����2����������x1��x2Ϊ��
% ����2���Ӵ�����ͷֱ������2�����������ĳЩ���������ý��������п����ɸ����������Ӵ���ϳɾ��и����ʺ϶ȵĸ��塣
% ��ʵ�Ͻ������Ŵ��㷨������������ͳ�Ż���������Ҫ�ص�֮һ��
%�Ŵ��㷨�ӳ���
%Name: crossover5.m
%����
%{
pop{1}={52;11;42;7;60;34;8;58;52;60;7;8;58;34;42;11}
pop{2}={60;42;52;8;34;7;58;11;7;11;58;8;34;42;52;60}
pop{3}={58;42;52;8;34;60;7;11;34;52;7;8;42;11;58;60}
pc=0.5
[newpop]=crossover2(pop,pc)
%}
function [newpop,record]=crossover6(pop,pc)
popsize=numel(pop(:,1));%��Ⱥ��С
record=zeros(popsize,1);%��¼���彻��Ϊ1��������Ϊ0
newpop=pop;
gen_length=numel(pop(1,:));%���峤��
if mod(popsize,2)==0
    loop_n=popsize;
else
    loop_n=popsize-1;
end
r=rand(loop_n,1);
for i=1:2:loop_n
    if r(i)<pc%С�ڽ�������򽻲棬
        record(i)=1;
        record(i+1)=1;
        parent_1=pop(i,:);%��ϵĵ�һ������
        parent_2=pop(i+1,:);%��ϵĵڶ�������   
        cross_point=randperm(gen_length-1,1);%ѡ�񽻲��
        pop_parents_i(1,:)=parent_1;
        pop_parents_i(2,:)=parent_2;
        [children1,children2]=sub_crossover(pop_parents_i,cross_point);
        newpop(i,:)=children1;
        newpop(i+1,:)=children2;
    else%������
        newpop(i,:)=pop(i,:);
        newpop(i+1,:)=pop(i+1,:);
    end
    
end

end
function [children1,children2]=sub_crossover(pop_parents,cross_point)
    parents1=pop_parents(1,:)';
    parents2=pop_parents(2,:)';
[~,lcob1]=ismember(parents1(cross_point+1:end),parents2);
    parents1_half=sortrows([lcob1,parents1(cross_point+1:end)]);
    [~,lcob2]=ismember(parents2(cross_point+1:end),parents1);
    parents2_half=sortrows([lcob2,parents2(cross_point+1:end)]);
    children1=[parents1(1:cross_point);parents1_half(:,end)];
     children2=[parents2(1:cross_point);parents2_half(:,end)];
end