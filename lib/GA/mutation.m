% 2018-1-1,�������޸ĺ����������ӹܵ���鲿�ֵĵı���
% ��һ���汾�������������pop������ֻ�йܵ��޸�����
% �����汾���������pop�����ǰһ���ǹܵ������򣬺�һ�����ܵ��޸�����
% ���ȣ�������ж��Ƿ���죬
% ������죬���������ȷ�����޸�������컹�Ǽ��������
%% ���� hanzhao@emails.bjut.edu.cn
%% 2017-12-19
%�Ŵ��㷨�ӳ���
%Name: mutation.m
%����
%{
pop{1}={52;11;42;7;60;34;8;58;52;60;7;8;58;34;42;11}
pop{2}={60;42;52;8;34;7;58;11;7;11;58;8;34;42;52;60}
pop{3}={58;42;52;8;34;60;7;11;34;52;7;8;42;11;58;60}
pm=1
newpop=mutation(pop,pm)
%}
function [newpop,record]=mutation(pop,pm)
popsize=numel(pop);
record=zeros(popsize,1);%��¼�������Ϊ1��������Ϊ0
gen_length=numel(pop{1});%���峤��
newpop=pop;
r=rand(popsize,1);
for pop_i=1:popsize
    if r(pop_i)<pm%�ж��Ƿ�������
        record(pop_i)=1;
        if rand(1)<=0.5%�����ڹܵ�������
            mutation_point=randperm(gen_length/2,2);
        else
            mutation_point=randperm(gen_length/2,2)+gen_length/2;
        end
        parent=cell2mat(pop{pop_i});
        child=parent;       
        child(mutation_point(1))=parent((mutation_point(2)));%����λ��
        child(mutation_point(2))=parent((mutation_point(1)));%����λ��
        newpop{pop_i}=num2cell(child);
    end
end

end