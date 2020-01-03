classdef unittessclass_CreateDamageNet <  matlab.unittest.TestCase
    %unittessclall_CreatDamageNet  对CreatDamageNet的测试文件
    %   此处显示详细说明    
    properties
        cdf  % CreateDamageNet
        cdf2  %
    end
    methods(Test)% 
        function testlib(testCase) % 加载dll pass
            testCase.cdf.loadLibrary;
            test  = libisloaded('EPANETx64PDD');
            testCase.verifyTrue(test) % 是否为真
        end
        function test_unloadlib(testCase) % 卸载dll pass
            testCase.cdf.unloadLibrary
            test = libisloaded('EPANETx64PDD');
            testCase.verifyFalse(test);
        end
        function test_addLibPath(testCase) % pass
            test = which('EPA_F.mat');
            testCase.verifyNotEmpty(test);
        end
        function test_creatDamageNet(testCase) % pass
            test = isfile('C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\materials\BAK\temp-BAK.inp');
            testCase.verifyFalse(test);
        end
        function test_get_net_data(testCase) % pass
            test1 = iscell(testCase.cdf.net_data);
            test2 = (numel(testCase.cdf.net_data)==27*2);
            test = all([test1,test2]);
            testCase.verifyTrue(test);
        end
        function test_get_damage_info(testCase) % pass
            test1 = iscell(testCase.cdf.damage_info);
            test2 = (testCase.cdf.damage_info{1}(1) == 25); % 第一个破坏管段为25
            test = all([test1,test2]);
            testCase.verifyTrue(test);
        end
        function test_export(testCase)
            testCase.cdf.export('1.inp')
            test = isfile('1.inp');
            testCase.verifyTrue(test);
            delete 1.inp
        end
    end
    methods(TestClassSetup) % 
        function Creat_cdf(testCase)            
            root = 'C:\Users\hc042\Documents\GitHub\a-comparison-of-2-technologies-that-analyze-resilience\';
            addpath([root,'lib\','Class\'])
            testCase.cdf = CreateDamageNet([root,'materials\BAK\BAK.inp'],[root,'materials\BAK\damage_1.txt']);          
        end
    end
    methods(TestClassTeardown) % 
    end
    methods(TestMethodSetup) % 
    end
    methods(TestMethodTeardown) % 
    end
end

