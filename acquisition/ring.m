classdef  ring < handle
  %RING implement circular buffer for double
  %   Detailed explanation goes here
  
  properties (SetAccess = private, GetAccess = public)
    data                    % buffer (initialized in constructor)
  end
  
  properties (Access = private)
    bufferSize
    index = 1
    list
    average                     % mean or average
    variance
    med                       % median
    stdev  % standard deviation
  end
  
  % constructor
  % -----------
  methods
    
    % constructor with the buffer size
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
    
    % compute save data, reset ring and compute result
    function compute(obj)
      obj.list = obj.data;
      obj.clear;
      obj.average = mean(obj.list);
      obj.med = median(obj.list);
      obj.variance = var(obj.list);
      obj.stdev = std(obj.list);
    end
    
    function result = getAverage(obj)
      result = obj.average;
    end
    function result = getMedian(obj)
      result = obj.med;
    end
    function result = getVariance(obj)
      result = obj.variance;
    end
    function result = getStd(obj)
      result = obj.stdev;
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
      testRing.compute;
      fprintf(1, 'Mean         = %f\n', testRing.getAverage);
      fprintf(1, 'Median       = %f\n', testRing.getMedian);
      fprintf(1, 'Variance     = %f\n', testRing.getVariance);
      fprintf(1, 'Standard dev = %f\n', testRing.getStd);
      % disp(testRing.data);
      success = true;
    end
    
  end % end of static methods
  
end % end of ring class

