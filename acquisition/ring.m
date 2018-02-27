classdef  ring < handle
  %RING implement circular buffer for double
  %   Detailed explanation goes here
  
  properties (Access = public)
    nanflag = 'omitnan'  % NaN condition, specified as one of these values:
    % 'includenan' — the variance of input containing NaN values is also NaN.
    % 'omitnan' — all NaN values appearing in either the input array or
    % weight vector are ignored.
  end
  
  properties (SetAccess = private, GetAccess = public)
    data                    % buffer (initialized in constructor)
    ringSize
    
  end
  
  properties (Access = private)
    index = 1
    list
    average              % mean or average
    variance
    med                  % median
    stdev                % standard deviation
    
    
  end
  
  % constructor
  % -----------
  methods
    
    % constructor with the buffer size
    function obj = ring(ringSize)
      obj.ringSize = ringSize;
      obj.data = nan(ringSize,1,'double')';
    end
    
    function clear(obj)
      obj.data = nan(obj.ringSize,1,'double')';
      obj.index = 1;
    end
    
    %  simply copy always all
    function  put(obj,value)
      assert(isa(value,'double'))
      obj.data(mod(obj.index-1, obj.ringSize)+1) = value;
      obj.index = obj.index + 1;
    end
    
    % compute save data, reset ring and compute result
    function compute(obj)
      obj.list = obj.data;
      obj.clear;
      obj.average = mean(obj.list, obj.nanflag);
      obj.med = median(obj.list, obj.nanflag);
      obj.variance = var(obj.list, obj.nanflag);
      obj.stdev = std(obj.list, obj.nanflag);
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
    
    function set.nanflag(obj, nanflag)
      if strcmp(nanflag, 'includenan') || strcmp(nanflag, 'ominan')
        obj.nanflag = nanflag;
      end
    end
    
  end % end of public methods
  
  methods(Static)
    
    % testing
    %--------
    function success = test(ringSize, maxValue)
      % success = false;
      testRing = ring(ringSize);
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

