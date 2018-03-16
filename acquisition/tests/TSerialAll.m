classdef TSerialAll < matlab.unittest.TestCase
  %UNTITLED Summary of this class goes here
  %   Each method tests parameters of serial port
  
  
  % Properties definition
  properties
    ports
    sp
    defaultPortOnHost = 'COM3'
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
    
    % Test Databits available
    function testDatabits(obj)
      dataBits = [7,8];
      obj.sp = us191.serial(obj.defaultPortOnHost);
      for db = dataBits
        obj.sp.setDataBits(db);
        obj.verifyEqual(obj.sp.getDataBits, db);
      end
    end
    
    % Test Stopbits available
    function testStopbits(obj)
      stopBits = [1,2];
      obj.sp = us191.serial(obj.defaultPortOnHost);
      for sb = stopBits
        obj.sp.setStopBits(sb);
        obj.verifyEqual(obj.sp.getStopBits, sb);
      end
    end
    
    % Test Status available
    function testStatus(obj)
      status = {'open', 'not connected'};
      obj.sp = us191.serial(obj.defaultPortOnHost);
      for s = status
        switch char(s)
          case 'open'
            obj.sp.open;
            obj.verifyEqual(obj.sp.getStatus, char(s));
             obj.sp.close;
          case 'not connected'
            obj.verifyEqual(obj.sp.getStatus, char(s));
        end
      end
    end
    
    % Test Parity available
    function testParity(obj)
      parity = {'none', 'odd', 'even'};
      obj.sp = us191.serial(obj.defaultPortOnHost);
      for p = parity
        obj.sp.setParity(char(p));
        obj.verifyEqual(obj.sp.getParity, char(p));
      end
    end
    
    % Test Terminator available
    function testTerminator(obj)
      terminator = {'CR/LF', 'CR', 'LF'};
      obj.sp = us191.serial(obj.defaultPortOnHost);
      for t = terminator
        obj.sp.setTerminator(char(t));
        obj.verifyEqual(obj.sp.getTerminator, char(t));
      end
    end
    
  end
  
end


