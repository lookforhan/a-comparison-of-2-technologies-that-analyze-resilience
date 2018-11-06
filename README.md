# a-comparison-of-2-technologies-that-analyze-resilience

## 前言

本项目是为了对比供水管网韧性分析的两种技术方法。

方法1：采用epanet2.dll自带的延时分析方法，分析供水管网从破坏到修复时间内的供水能力曲线。

方法2：采用epanet2.dll自带的单时刻分析方法，人工确定分析时间步，分析供水管网从破坏到修复时间内的供水能力曲线。

## 理论与材料

### [材料](.\materials\)

- **EPANETx64PDD.dll**
- **toolkit.h**
- **MATLAB**
- **anytown.inp**

本项目所采用的工具为**EPANETx64PDD.dll**、**toolkit.h**[@morley2008pressure]进行水力分析和pdd模型的水力计算。

采用matlab进行开发，当中涉及水力计算部分，调用上述动态链接库完成。

为了更好研究延时模拟与静态（单时刻）分析的区别，将对angytown.inp进行一定的修改：

1. 去除tank
2. 去除pump
3. 所有用户节点需水量变化曲线相同
4. **EPANETx64PDD.dll**中采用pdd分析时对标准epanet的inp文件需要做一定的修改。修改原则详见报告[《Technical Note 2008-02 Pressure Driven Demand Extension for EPANET》](https://ore.exeter.ac.uk/repository/bitstream/handle/10871/14721/Technical%20Note%202008-02%20Pressure%20Driven%20Demand%20Extension%20for%20EPANET.pdf?sequence=4&isAllowed=y)


### 理论
