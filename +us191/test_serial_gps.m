classdef test_serial_gps < matlab.unittest.TestCase
    %UNTITLED Summary of this class goes here
    %   Each method tests parameters of serial port
    
    
    % Properties definition
    properties
        port = 'COM7';
        baudrate = 4800;
    end
    
    % Class public methods
    methods
        
        % Constructor
        function obj = value(valuebaudrate, valueport)
            obj.valuebaudrate = valuebaudrate;
            obj.valueport = valueport;
            obj = us191.serial(obj.port);
        end
        
    end
    
    % Method for Tests
    methods (Test)
        
        function set(obj)
            obj.setBaudRate(obj.baudrate);
        end  
        
        %Test all parameters
        function test(testCase)
            
            testCase.valuebaudrate = us191.serial.getbaudrate;
            testCase.valueport = us191.serial.getport;
            verifyEqual(testCase, testCase.baudrate, testCase.valuebaudrate);
            verifySubstring(testCase, testCase.port, testCase.valueport);
            %testCase.verifyClass(testCase.Port_Test,'char')
            
        end
        
    end
    
end


