classdef TExtract < matlab.unittest.TestCase
  %UNTITLED Summary of this class goes here
  %   Each method tests parameters of serial port
  
  
  % Properties definition
  properties
    decoder
    trame = {'12B788195AD281484A13196918C0A5784563BCB1A508C029118B774150234720B153FCD066B458',...
     '0C6C77150B2C850F460CBD28148934AB1972E7712F08C068118BA840D02B4720A3E3FC506FB458' }
    freq = {33096.289, 34063.273}
    temp = {26.88,24.13}

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
        s = obj.decoder.extract(theTrame);
        obj.verifyEqual(s.frequencies(3), obj.freq{i},'AbsTol',0.001,...
            'Difference between actual and expected exceeds relative tolerance');
        obj.verifyEqual(s.PressureTemperature, obj.temp{i},'AbsTol',0.01,...
            'Difference between actual and expected exceeds relative tolerance');

      end
    end
  end
  
end



