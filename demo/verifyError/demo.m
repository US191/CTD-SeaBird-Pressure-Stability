classdef demo < handle
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties (Access = private)
    baudRate = 4800
  end
  
  methods
    
    function setBaudRate(obj, baudRate)
      switch baudRate
        case {300,600,1200,2400,4800,9600,19200,57600,112000}
          obj.baudRate = baudRate;
        otherwise
          error( 'matlab:demo:invalidbaud','MATLAB:demo:invalid: baud rate value: %d', baudRate);
      end
    end
    
    function baudRate = getBaudRate(obj)
      baudRate = obj.baudRate;
    end
    
  end
end

