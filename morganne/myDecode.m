classdef myDecode < handle
  
  properties
    nFreq = 5      % default, 5 frequency
    sizeFreq = 6   % default, 6 bytes per hex freq
  end
  
  methods % public
    
    % constructor
    function obj = myDecode(varargin)
      
      obj.nFreq = varargin{1};
      if nargin > 1
        obj.sizeFreq = varargin{2};
      end
    end
    
    % example: trame = '106B570ACF6883646910BA460A87706DEFFF882FFFFFFFFFFFFFFF000000719241';
    function frequencies = extract(obj, trame)
      frequencies = ones(obj.nFreq, 1);
      p = 1;
      for i = 1:1:obj.nFreq
        bytes = trame(p:p+obj.sizeFreq);
        
        theFreq = hex2dec([bytes(1),bytes(2);bytes(3),bytes(4);bytes(5),bytes(6)]);
        frequencies(i) = theFreq(1)*256 + theFreq(2) + theFreq(3)/256;
        p = p + obj.sizeFreq;
      end
    end % end of extract
    
  end  % end of methods
  
end % end of class