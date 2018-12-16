classdef unittestclassforgreedyIsolation < matlab.unittest.TestCase
    properties
        obj_greedy_isolation % �?��对象
    end
    methods(Test)% �?��测试�?
        function test_break_pipe_id_num(testCase)
            testCase.verifyEqual(testCase.obj_greedy_isolation.n_break_pipe,5);
            testCase.verifyEqual(roundn(testCase.obj_greedy_isolation.current_system_serviceablity,-4),0.4376);
        end
    end
    methods(TestClassSetup) % 在创建该类的时刻进行测试
        function creatGreedyIsolation(testCase)
            load('test_greedy_data');
            isolation_time_mat = ones(sum(damage_pipe_info{3}==2),1)*0.5;
            break_pipe_id = damage_pipe_info{5}(damage_pipe_info{3}==2,1);
           testCase.obj_greedy_isolation = greedy_pipe_isolation_priority(temp_inp_file,net_data,break_pipe_id,isolation_time_mat,pipe_relative); 
        end
    end
    methods(TestClassTeardown) % 在测试结束时，运行一�?
    end
    methods(TestMethodSetup) % 保证测试�?��前，恢复到初始状�?w

    end
    methods(TestMethodTeardown) % 保证测试结束后，处理结束状�?
    end
end
