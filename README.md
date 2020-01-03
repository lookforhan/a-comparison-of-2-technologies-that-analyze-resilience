# a-comparison-of-2-technologies-that-analyze-resilience

## 前言

本项目是为了对比供水管网韧性分析的两种技术方法。

方法1：采用EPANETx64PDD.dll自带的延时分析方法，分析供水管网从破坏到修复时间内的供水能力曲线。

方法2：采用EPANETx64PDD.dll自带的单时刻分析方法，人工确定分析时间步，分析供水管网从破坏到修复时间内的供水能力曲线。

## 理论与材料

### [材料](.\materials\)


- **EPANETx64PDD.dll**
- **toolkit.h**
- **MATLAB**
- **[anytown.inp](https://emps.exeter.ac.uk/media/universityofexeter/emps/research/cws/downloads/anytown.inp)**
- **[mod.inp](http://emps.exeter.ac.uk/engineering/research/cws/resources/benchmarks/design-resiliance-pareto-fronts/large-problems/)**
本项目所采用的工具为**EPANETx64PDD.dll**、**toolkit.h**[@morley2008pressure]进行水力分析和pdd模型的水力计算。

采用matlab进行开发，当中涉及水力计算部分，调用上述动态链接库完成。


1. **EPANETx64PDD.dll** 中采用pdd分析时对标准epanet的inp文件需要做一定的修改。修改原则详见报告[《Technical Note 2008-02 Pressure Driven Demand Extension for EPANET》](https://ore.exeter.ac.uk/repository/bitstream/handle/10871/14721/Technical%20Note%202008-02%20Pressure%20Driven%20Demand%20Extension%20for%20EPANET.pdf?sequence=4&isAllowed=y)


### 理论

1. 管网震后破坏模型

2. 管网震后功能分析方法

3. 管网震后管道修复次序



## 案例分析

### 案例描述
MOD.inp是标准EPANET的inp文件，为了使用EPANETx64PDD.dll中的PDD计算，必须在inp文件中[EMITTERS]部分中增加节点编号、最低水压0m、需求水压20m。 -> MOD_2.inp

增加节点需水量曲线。从anytown.inp中复制其中的1号曲线。增加模拟时长为24小时。 -> MOD_3.inp

初步验证成功，详见test.m
### 结果

## 修改记录
### 2020/01/03
* 之前的记录并未保存。记录最近一段时间的修改记录。
* 增加考虑阀门位置形成分区的功能。
* 分区数据保存在"\lib_valves\Class\mod_segment.mat"
修改的函数及修改内容说明

函数 |  位置  | 说明  | 修改位置
 :---:| :---: | :-: | :-----
EPS_net_EPANETx64PDD.m|\lib_valves\Class\ | 进行延时模拟 | 修改管道状态部分，加载分区信息。
event_time2.m | \lib_valves\eventTime | 计算隔离管道与修复管道所需时间 | 修改隔离管道时间计算，加载分区信息
greedy_pipe_isolation_priority.m | \lib_valves\Class\ | 遍历隔离每个断开管道 | 加载分区信息，隔离破坏管道所在区域，同时修改管道的当前状态与初始状态
greedy_pipe_recovery_priority.m | \lib_valves\Class\ | 遍历修复每个破坏管道 |  加载分区信息，隔离破坏管道所在区域，同时修改管道的当前状态与初始状态
greedyImportance_priority.m | \lib_valves\toolkit\ | 贪心算法排序 | 增加输出计算书，在命令行中显示，每一步的各个管道的计算结果。

## 讨论

## 结论
