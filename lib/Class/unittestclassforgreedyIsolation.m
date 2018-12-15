classdef unittestclassforgreedyIsolation < matlab.unittest.TestCase
    properties
        obj_greedy_isolation % 一个对象
    end
    methods(Test)% 一般测试点
    end
    methods(TestClassSetup) % 在创建该类的时刻进行测试
        function creatGreedyIsolation(testCase)
            
        end
    end
    methods(TestClassTeardown) % 在测试结束时，运行一次
    end
    methods(TestMethodSetup) % 保证测试开始前，恢复到初始状态
    end
    methods(TestMethodTeardown) % 保证测试结束后，处理结束状态
    end
end
