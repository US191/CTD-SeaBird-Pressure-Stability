classdef TXmlcon < matlab.unittest.TestCase
  %UNTITLED Summary of this class goes here
  %   Each method tests parameters of serial port
  
  
  % Properties definition
  properties
    map
    xmlFile = '1263.xml'
    keyMap = {'CalibrationDate','SerialNumber','C1','C2','C3','D1',...
      'D2','T1','T2','T3','T4','Slope','Offset','T5','AD590M','AD590B'};
    valueMap = {'15-Dec-15', 1263, -4.023025e+004,-4.466859e-001,1.240000e-002,...
      3.511700e-002, 0.000000e+000, 3.023099e+001, -4.469710e-004, 4.128850e-006,...
      2.885040e-009, 1.00000000, 0.00000, 0.000000e+000, 1.279148e-002,-9.405686e+000};
  end
  
  % Each method in that block is identified as a method responsible for setting
  % up a test fixture that is shared over all test methods in that class.
  % ---------------------------------------------------------------------
  methods(TestClassSetup )
    
    % setup intialize an serial instance by default
    function setup(obj)
      obj.map = readXmlcon(obj.xmlFile);
    end
  end
  
  % method block to contain test methods
  % ------------------------------------
  methods (Test)
    
    % Test port available on host
    function testFile(obj)
      for i = 1:length(obj.keyMap)
        theKey = obj.keyMap{i};
        obj.verifyEqual(obj.map(theKey), obj.valueMap{i});
      end
    end
  end
  
end



