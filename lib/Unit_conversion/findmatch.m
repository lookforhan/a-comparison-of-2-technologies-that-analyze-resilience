%% 说明
% 1.程序（函数）的功能，依据的原理，参考文献；
% % 功能：确定关键字在关键词cell中的顺序位置；
% 2.正常运行需要调用的其他自编（自定义）程序（函数）？
% % 无
% 3.调用此程序（函数）的程序？
% % CAM CIM PcR ?creat_junctions ?din ?netsize
% 4.输入变量：名称，数据类型，每列（行）数据的含义及单位，输入变量的来源：程序赋值，数据文件读入，调用其他程序（函数）录入；
% %         str，字符串
% %         keyword，cell，字符cell
% %         n1，全局变量，对比字符个数
% 5.输出变量：名称，数据类型，每列（行）数据的含义及；
% %         count_num,在字符cell中位置；
% 6.编程思路，程序特点；
% 7.程序编写人，编写（更新）时间，本次版本更新的bug，未来版本需要修改或提升的地方备注
% % 程序编写人：韩朝；最后修改时间：2017-4-12 19：43；本版本更新bug：增加文件头部说明；未来版本需要修改：考虑优化keyword_num
function count_num=findmatch(str,keyword,n1)
%输入：str为目标字符串，keyword 为字符串库,n1为比较的精度；输出：str再keyword的位置
 keyword_num=length(keyword);
count_num=-1;
    for n=1:keyword_num
        check=strncmp(str,keyword{n},n1);%为了效率仅选取前3个字符比较
        if check==1%表示字符相同
            count_num=n;
        break;
        end
    end 
end