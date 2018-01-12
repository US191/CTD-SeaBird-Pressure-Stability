classdef TSerialAll < matlab.unittest.TestCase
  %UNTITLED Summary of this class goes here
  %   Each method tests parameters of serial port
  
  
  % Properties definition
  properties
    ports
    sp
    defaultPortOnHost = 'COM9'
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
    
    % Test port available on host
    function testPort(obj)
      for p = obj.ports'
        port = char(p);
        obj.sp = us191.serial(port);
        obj.sp.setPort(port);
        obj.verifyEqual(obj.sp.getPort, port);
      end
    end
    
    % Test baurate available
    function testBaurate(obj)
      baudRates = [300,600,1200,2400,4800,9600,19200,57600,112000];
      obj.sp = us191.serial(obj.defaultPortOnHost);
      for bd = baudRates
        obj.sp.setBaudRate(bd);
        obj.verifyEqual(obj.sp.getBaudRate, bd);
      end
    end
    
  end
  
end


