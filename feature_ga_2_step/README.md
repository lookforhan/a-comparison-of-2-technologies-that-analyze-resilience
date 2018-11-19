# 功能：采用两阶段遗传优化

为了优化供水管网震后隔离和修复次序。采用两阶段优化方法
基于eps_different_crew_startTime.m修改。在91行修改，调用ga_priority8_epanetx64pdd.m -> ga_priority9_epanetx64pdd.m.

# ga_priority9_epanetx64pdd.m函数的主要修改

## 第一阶段，优化隔离次序

## 第二阶段，优化修复次序

## 第三阶段，将最优的隔离次序和最优的修复次序合并

# priorityList2schedule10_2_step_one.m函数的修改

本函数是在priorityList2schedule9.m函数的基础上进行的修改。修改为只安排隔离的工作时间表。

