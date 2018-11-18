# 修改函数为多个修复队伍同时工作
## 修改目标如下

* 每个队伍的工作开始时间不同
* 每个对物的修复效率不同
* 每个队伍的移动速度不同
* 每个队伍的隔离效率不同

## 主函数修改内容

在主函数eps_different_crew_startTime.m中增加参数

crewStartTime|记录每个队伍开始工作的时间（单位：小时）
crewEfficiencyRecovery|记录每个队伍的修复效率系数
crewEfficiencyIsolation|记录每个队伍的隔离效率系数
crewEfficiencyTravel|记录每个队伍的移动效率系数

## 功能函数中的修改

1. 在priorityList2schedule8.m的基础上建立priorityList2schedule9.m函数。该函数增加了输入参数，使每个队伍修复过程中考虑了修复效率、隔离效率、移动效率及开始修复的时间。
2. 在fit5.m的基础上新建了fit6.m函数，在第60行增加了priorityList2shcedule9.m的输入参数。并增加fit6.m的输入参数。
3. 在ga_priority7_epanetx64pdd.m函数的基础上新建了ga_priority8_epanetx64pdd.m函数。并增加函数的输入参数。并且修改第33行调用calfitvalue3.m函数，改为calfitvalue4.m增加了输入参数。
4. 在calfitvalue4.m函数中增加了输入参数，并且修改47行fit5->fit6,并且增加了输入参数。
