classdef  ring < handle
  %RING implement circular buffer for double
  %   Detailed explanation goes here
  
  properties (SetAccess = private, GetAccess = public)
    data                    % buffer (initialized in constructor)
    bufferSize
    index = 1
  end
  
  % constructor
  % -----------
  methods
    
    function obj = ring(bufferSize)
      obj.bufferSize = bufferSize;
      obj.data = nan(bufferSize,1,'double')';
    end
    
    function clear(obj)
      obj.data = nan(obj.bufferSize,1,'double')';
      obj.index = 1;
    end
    
    %  simply copy always all
    function  put(obj,value)
      assert(isa(value,'double'))
      obj.data(mod(obj.index-1, obj.bufferSize)+1) = value;
      obj.index = obj.index + 1;
    end
    
  end % end of public methods
  
  methods(Static)
    
    % test
    %-------
    function success = test(bufferSize, maxValue)
      success = false;
      testRing = ring(bufferSize);
      for ind = 1:maxValue
        testRing.put(ind)
        disp(testRing.data);
      end
      testRing.clear;
      disp(testRing.data);
    end
    
  end % end of static methods
  
end % end of ring class

