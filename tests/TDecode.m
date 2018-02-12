classdef TDecode < matlab.unittest.TestCase
  %UNTITLED Summary of this class goes here
  %   Each method tests parameters of serial port
  
  
  % Properties definition
  properties
    decoder
    trame = {...
      '106B570ACF6883646910BA460A87706DEFFF882FFFFFFFFFFFFFFF000000719241',...
      '0C6C77150B2C850F460CBD28148934AB1972E7712F40D02B472FF0000000A3E3FC' }
    freq = {33636.410, 34063.273}
    rawTemp = {1817 , 2622}
    modulo = {65, 252}
  end
  
  % Each method in that block is identified as a method responsible for setting
  % up a test fixture that is shared over all test methods in that class.
  % ---------------------------------------------------------------------
  methods(TestClassSetup )
    
    % setup intialize an serial instance by default
    function setup(obj)
      obj.decoder = myDecode();
    end
  end
  
  % method block to contain test methods
  % ------------------------------------
  methods (Test)
    
    % Test port available on host
    function testFreq(obj)
      for i = 1:length(obj.trame)
        theTrame = obj.trame{i};
        s = obj.decoder.decode(theTrame);
        obj.verifyEqual(s.frequencies(3), obj.freq{i},'AbsTol',0.001,...
            'Difference between actual and expected exceeds relative tolerance');
        obj.verifyEqual(s.pressureTemperature, obj.rawTemp{i});
     obj.verifyEqual(s.modulo, obj.modulo{i});
      end
    end
  end
  
end



