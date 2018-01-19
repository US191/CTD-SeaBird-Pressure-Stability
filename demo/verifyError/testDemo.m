classdef testDemo < matlab.unittest.TestCase
  %UNTITLED Summary of this class goes here
  %   Each method tests parameters of serial port
  
  
  % Properties definition
  properties
  end
    
  % method block to contain test methods
  % ------------------------------------
  methods (Test)
    
    % Test baurate available
    function testBauRate(obj)
      baudRates = [300,600,1200,2400,4800,9600,19200,57600,112000];
      s = demo;
      for bd = baudRates
        s.setBaudRate(bd);
        obj.verifyEqual(s.getBaudRate, bd);
      end
    end
    
    % Test Error Databits available
    function testErrorBaudRate(obj)
      baudRate = 4801;
      s = demo;
      %t = @(x) s.setBaudRate(x);
      %obj.verifyError(t(baudRate),...
      %  sprintf('MATLAB:demo:invalid data bit value: %d', baudRate)); 
        obj.verifyError(@() s.setBaudRate(baudRate), 'matlab:demo:invalidbaud'); 
    end
    
  end
end

