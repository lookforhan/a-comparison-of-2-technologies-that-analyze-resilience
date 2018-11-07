%% 2017-12-12
%% 韩朝 hanzhao@emails.bjut.edu.cn
%% 生成服从三角分布随机数
%% 输入
% a;最小值
% b;最大值
% c;众数
%% 输出
% num_rnd;随机数
function num=triangular_distribution(a,b,c)
y = rand(1,1);%产生随机数（0，1）均匀分布随机数
if y<=((c-a)/(b-a))
    x=a+sqrt(y*(b-a)*(c-a));
else
    x=b-sqrt((b-a)*(b-c)*(1-y));
end
num=x;

end