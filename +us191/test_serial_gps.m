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
            obj = us191.serial(obj.port);
            
        end
    end
    
    % Method for Tests
    
    methods (Test)
        % Test Baudrate
        function get_baudrate(obj)
            
            obj.setbaudrate(obj.baudrate);
            obj.valuebaudrate = obj.getbaudrate;
            verifyEqual(testCase, testCase.baudrate, testCase.valuebaudrate);
        end
        
        % Test Baudrate
        function get_port(obj)
            s.setport(obj.port);
            obj.valueport = s.getport;
            verifySubstring(testCase, testCase.port, testCase.valueport);
            %             testCase.verifyClass(testCase.Port_Test,'char')
            
        end
        
    end
    
end


