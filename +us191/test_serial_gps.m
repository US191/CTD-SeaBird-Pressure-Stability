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
        function obj = get(valuebaudrate, valueport)
            
            obj.valuebaudrate = valuebaudrate;
            obj.valueport = valueport;
           
            
        end
    end
    
    % Method for Tests
    
    methods (Test)
        % Test Baudrate
        function test_baudrate(obj)
            obj = us191.serial(obj.port);
            obj.setBaudRate(obj.baudRate);
            obj.valuebaudrate = obj.getBaudRate;
            verifyEqual(testCase, testCase.baudrate, testCase.valuebaudrate);
        end
        
        % Test Baudrate
        function test_port(obj)
             obj = us191.serial(obj.port);
            obj.valueport = obj.getPort;
            verifySubstring(testCase, testCase.port, testCase.valueport);
            %testCase.verifyClass(testCase.Port_Test,'char')
            
        end
        
    end
    
end


