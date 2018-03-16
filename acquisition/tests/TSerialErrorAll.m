classdef TSerialErrorAll < matlab.unittest.TestCase
    %UNTITLED Summary of this class goes here
    %   Each method tests parameters of serial port
    
    
    % Properties definition
    properties
        ports
        sp
        defaultPortOnHost = 'COM7'
    end
    
    % Each method in that block is identified as a method responsible for setting
    % up a test fixture that is shared over all test methods in that class.
    % ---------------------------------------------------------------------
    methods(TestClassSetup )
        
        % setup intialize an serial instance by default
        function setup(obj)
            obj.ports = us191.serial.Discover;
        end
    end
    
    % method block to contain test methods
    % ------------------------------------
    methods (Test)
        
        % Test Error Databits available
        function testErrorDatabits(obj)
            dataBits = 9;
            % test with setter
            s = us191.serial(obj.defaultPortOnHost);
            obj.verifyError(@() s.setDataBits(dataBits),'matlab:serial:invalidDataBits');
            % test from constructor
            obj.verifyError(@()  us191.serial(obj.defaultPortOnHost,'databits' ,dataBits),...
                'matlab:serial:invalidDataBits');
        end
        
        % Test Error BaudRate available
        function testErrorBaudRate(obj)
            baudRate = 4801;
            % test with setter
            s = us191.serial(obj.defaultPortOnHost);
            obj.verifyError(@() s.setBaudRate(baudRate),'matlab:serial:invalidBaudRate');
            % test from constructor
            obj.verifyError(@()  us191.serial(obj.defaultPortOnHost,'baudrate' ,baudRate),...
                'matlab:serial:invalidBaudRate');
        end
        
        % Test Error Parity available
        function testErrorParity(obj)
            parity = 'ody';
            % test with setter
            s = us191.serial(obj.defaultPortOnHost);
            obj.verifyError(@() s.setParity(parity),'matlab:serial:invalidParity');
            % test from constructor
            obj.verifyError(@()  us191.serial(obj.defaultPortOnHost,'parity' ,parity),...
                'matlab:serial:invalidParity');
        end
        
        % Test Error StopBits available
        function testErrorStopBits(obj)
            stopBits = 5;
            % test with setter
            s = us191.serial(obj.defaultPortOnHost);
            obj.verifyError(@() s.setStopBits(stopBits),'matlab:serial:invalidStopBits');
            % test from constructor
            obj.verifyError(@()  us191.serial(obj.defaultPortOnHost,'stopBits' ,stopBits),...
                'matlab:serial:invalidStopBits');
        end
        
        
        % Test Error Terminator available
        function testErrorTerminator(obj)
            terminator = 'end';
            % test with setter
            s = us191.serial(obj.defaultPortOnHost);
            obj.verifyError(@() s.setTerminator(terminator),'matlab:serial:invalidTerminator');
            % test from constructor
            obj.verifyError(@() us191.serial(obj.defaultPortOnHost,'terminator' ,terminator),...
                'matlab:serial:invalidTerminator');
        end
        
        
        % Test Error all parameters from constructor
        function testError(obj)
            obj.sp = us191.serial(obj.defaultPortOnHost);
            
            %Structure
            field1 = 'val';
            value = {900, 9, 'egg', 5, 'end'};
            
            field2 = 'prop';
            properties = {'baudRate', 'dataBits', 'parity', 'stopBits', 'terminator'};
            
            field3 = 'ident';
            ID = {'matlab:serial:invalidBaudRate','matlab:serial:invalidDataBits',...
                'matlab:serial:invalidParity', 'matlab:serial:invalidStopBits',...
                'matlab:serial:invalidTerminator'};
            
            s = struct(field1, value, field2, properties, field3, ID);
            
            for i = 1:5
                obj.verifyError(@()us191.serial(obj.defaultPortOnHost,s(i).prop ,s(i).val),s(i).ident);
            end
        end
    end
end

