classdef TSerialErrorAll < matlab.unittest.TestCase
  %UNTITLED Summary of this class goes here
  %   Each method tests parameters of serial port
  
  
  % Properties definition
  properties
    ports
    sp
    defaultPortOnHost = 'COM16'
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
      obj.verifyError(@() us191.serial(obj.defaultPortOnHost, 'DataBits',dataBits),...
        sprintf('MATLAB:serial:invalid data bit value: %d', dataBits));
      
    end
  end
end

