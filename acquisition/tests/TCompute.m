classdef TCompute < matlab.unittest.TestCase
  %UNTITLED Summary of this class goes here
  %   Each method tests parameters of serial port
  
  
  % Properties definition
  properties
    fileXmlcon = {'1209.xml','1263.xml'};
    trame = {...
      '106B570ACF6883646910BA460A87706DEFFF882FFFFFFFFFFFFFFF000000719241',...
      '0C6C77150B2C850F460CBD28148934AB1972E7712F40D02B472FF0000000A3E3FC' }
    pressure = {0.502, 1653.143}
    temp = {13.95,24.13}
    hexFile = 'fr27001.hex'
    cnvFile = 'fr27001.cnv'
  end
  
  % Each method in that block is identified as a method responsible for setting
  % up a test fixture that is shared over all test methods in that class.
  % ---------------------------------------------------------------------
  methods(TestClassSetup )
    
    % setup intialize an serial instance by default
    %     function setup(obj)
    %     end
  end
  
  % method block to contain test methods
  % ------------------------------------
  methods (Test)
    
    %
    function testPressure(obj)
      for i = 1:length(obj.trame)
        md = decode();
        mc = compute(obj.fileXmlcon{i});
        theTrame = obj.trame{i};
        raw = md.decodeTrame(theTrame);
        t = mc.computeTemp(raw.pressureTemperature);
        p = mc.computePress(raw.frequencies(3), t);
        obj.verifyEqual(p, obj.pressure{i},'RelTol',0.01,...
          'Difference between actual and expected exceeds relative tolerance');
        obj.verifyEqual(t, obj.temp{i},'RelTol',0.01,...
          'Difference between actual and expected exceeds relative tolerance');
      end
    end
    
    function testPressureFromFile(obj)
      fidHex = fopen(obj.hexFile,'r');
      fidCnv = fopen(obj.cnvFile,'r');
      md = decodeFromFile(5,4,0);
      mc = compute(obj.fileXmlcon{2});
      while ~feof(fidHex)
        theTrame = fgetl(fidHex);
        theBuf = fgetl(fidCnv);
        theData = sscanf(theBuf,'%f');
        P = theData(3);
        F = theData(15);
        TP = theData(16);
        raw = md.decodeTrame(theTrame);
        t = mc.computeTemp(raw.pressureTemperature);
        p = mc.computePress(raw.frequencies(3), t);
        obj.verifyEqual(raw.frequencies(3), F,'RelTol',0.001,...
          'Difference between actual and expected exceeds relative tolerance');
        obj.verifyEqual(t, TP,'RelTol',0.01,...
          'Difference between actual and expected exceeds relative tolerance');
        obj.verifyEqual(p, P,'RelTol',0.01,...
          'Difference between actual and expected exceeds relative tolerance');
      end
      
    end
  end
  
end



