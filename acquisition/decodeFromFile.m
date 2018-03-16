classdef decodeFromFile < handle
  
  properties
    nFreq = 5      % default, 5 frequency
    nVolt = 8      % default, 8 Voltage channel
    spar  = 0      %
    position = 1
    time = 1
  end
  
  %Size all parameters
  properties (Access = private)
    sizeFreq = 6   % 3 bytes per freq (24 bit)
    sizeVolt = 3   % 1.5 byte per voltage (12 bit)
    sizeSPar = 6   % 3 bytes
    sizePosition = 14
    sizeTime = 8
    sizeP_t  = 4   % 1.5 byte + status 0.5
    sizeModulo = 2 % 1 byte
  end
  
  methods % public
    
    % constructor
    function obj = decodeFromFile(varargin)
      
      if nargin == 1
        obj.nFreq = varargin{1};
      end
      if nargin == 2
        obj.nFreq = varargin{1};
        obj.nVolt = varargin{2};
      end
      if nargin == 3
        obj.nFreq = varargin{1};
        obj.nVolt = varargin{2};
        obj.spar = varargin{3};
      end
    end
    
    % example: trame = '12B788195AD281484A13196918C0A5784563BCB1A508C029118B774150234720B153FCD066B458';
    function s = decodeTrame(obj, trame)
      pointer = 1;
      % extract frequencies
      frequencies = ones(obj.nFreq, 1);
      for i = 1:1:obj.nFreq
        bytes = trame(pointer : pointer + obj.sizeFreq -1);
        frequencies(i) = hex2dec(bytes(1:2))*256 + hex2dec(bytes(3:4)) + ...
          hex2dec(bytes(5:6))/256;
        pointer = pointer + obj.sizeFreq;
      end
      s.frequencies = frequencies;
      
      % step voltages and SPAR
      pointer = pointer + (obj.sizeVolt * obj.nVolt) + ...
        obj.sizeSPar * obj.spar;
      % step position and time
      pointer = pointer + (obj.sizePosition * obj.position) + ...
        (obj.sizeTime * obj.time);
      
      % extract Pressure temp included status
      bytes = trame(pointer : pointer + obj.sizeP_t -1);
      s.pressureTemperature = hex2dec(bytes(1:2))*16 + hex2dec(bytes(3));
      pointer = pointer + obj.sizeP_t;
      
      % extract modulo
      bytes = trame(pointer : pointer + obj.sizeModulo -1);
      s.modulo = hex2dec(bytes);
      
    end % end of decodeFromFile
    
  end  % end of methods
  
end % end of class