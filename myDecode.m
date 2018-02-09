classdef myDecode < handle
  
  properties
    nFreq = 5      % default, 5 frequency
    nVolt = 8      % default, 8 Voltage channel
  end
  
  %Size all parameters
  properties (Access = private)
    sizeFreq = 6   % default, 6 bytes per hex freq
    sizeVolt = 3   % default, 3 bytes per hex volt
    sizePar = 3    % default, 3 bytes
    sizeP_t = 3    % default, 3 bytes
    sizeCount = 2  % default, 2 bytes
    sizeDummy = 3
    pointer = 1    
  end
  
  methods % public
    
    % constructor
    function obj = myDecode(varargin)
      
      if nargin == 1
        obj.nFreq = varargin{1};
      end
      if nargin > 1
        obj.nFreq = varargin{1};
        obj.nVolt = varargin{2};
      end
    end
    
    % example: trame = '12B788195AD281484A13196918C0A5784563BCB1A508C029118B774150234720B153FCD066B458';
    function s = extract(obj, trame)
      frequencies = ones(obj.nFreq, 1);
      for i = 1:1:obj.nFreq
        bytes = trame(obj.pointer : obj.pointer + obj.sizeFreq);
        
        theFreq = hex2dec([bytes(1),bytes(2);bytes(3),bytes(4);bytes(5),bytes(6)]);
        frequencies(i) = theFreq(1)*256 + theFreq(2) + theFreq(3)/256;
        obj.pointer = obj.pointer + obj.sizeFreq;
      end
      s.frequencies = frequencies;
      obj.pointer = obj.pointer + (obj.sizeVolt * obj.nVolt) + obj.sizeDummy + obj.sizePar;
      bytes = trame(obj.pointer : obj.pointer + obj.sizeP_t);
      s.PressureTemperature = hex2dec(bytes(1:3));
    end % end of extract
    
  end  % end of methods
  
end % end of class