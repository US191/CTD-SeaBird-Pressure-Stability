classdef decode < handle
  
  properties
    nFreq = 5      % default, 5 frequency
    nVolt = 8      % default, 8 Voltage channel
  end
  
  %Size all parameters
  properties (Access = private)
    sizeFreq = 6   % 3 bytes per freq (24 bit)
    sizeVolt = 3   % 1.5 byte per voltage (12 bit)
    sizeSPar = 0   % 3 bytes
    sizeP_t  = 4   % 1.5 byte + status 0.5
    sizeModulo = 2 % 1 byte
  end
  
  methods % public
    
    % constructor
    function obj = decode(varargin)
      
      if nargin == 1
        obj.nFreq = varargin{1};
      end
      if nargin > 1
        obj.nFreq = varargin{1};
        obj.nVolt = varargin{2};
      end
    end
    
    % example: trame = '106B570ACF6883646910BA460A87706DEFFF882FFFFFFFFFFFFFFF000000719241';
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
      pointer = pointer + (obj.sizeVolt * obj.nVolt) + obj.sizeSPar;
      
      % extract Pressure temp included status
      bytes = trame(pointer : pointer + obj.sizeP_t -1);
      s.pressureTemperature = hex2dec(bytes(1:2))*16 + hex2dec(bytes(3));
      pointer = pointer + obj.sizeP_t;
      
      % extract modulo
      bytes = trame(pointer : pointer + obj.sizeModulo -1);
      s.modulo = hex2dec(bytes);
      
    end % end of decode
    
  end  % end of methods
  
end % end of class