classdef Tstat < matlab.unittest.TestCase
    
    properties
        A = [ 0.733 0.785 0.713 0.785 0.733...
            0.733 0.785 0.713  0.733 0.785...
            0.733 0.733 0.759 0.733 0.785,...
            0.733 0.687 0.785 0.759 0.733,...
            0.733 0.785 0.733 0.759 0.733];
        
        B = [ 0.733 0.733 0.733 0.759 0.785...
            0.733 0.733 0.785 0.713  0.785...
            0.733 0.733 0.733 0.733 0.759...
            0.733  0.785 0.733 0.733 0.759...
            0.733 0.733 0.733 0.785 0.713];
        
        C = [ 0.785 0.733 0.733 0.733, 0.759...
            0.733 0.785  0.733 0.733 0.733...
            0.759 0.733  0.785 0.733  0.785...
            0.713 0.733 0.733 0.785 0.733...
            0.759  0.733  0.733  0.785 0.733];
        
%         
%        D = [ 0.759 0.733 0.785 0.733 0.785...
%            0.759 0.687 0.785 0.733 0.785...
%            0.759 0.733 0.733 0.733 0.785...
%            0.733 0.759 0.733 0.733 0.785...
%            0.733 0.759 0.733 0.733 0.785]
        
        
    end
    
    methods(Test)
        function teststat(obj)
            
            s = stat();
            s.read;
            s.statistique;
            obj.verifyEqual(s.average(1), mean(obj.A));
            obj.verifyEqual(s.average(2), mean(obj.B));
            obj.verifyEqual(s.average(3), mean(obj.C));
%             obj.verifyEqual(s.average(23), mean(obj.D));
            
            obj.verifyEqual(s.variance(1), var(obj.A));
            obj.verifyEqual(s.variance(2), var(obj.B));
            obj.verifyEqual(s.variance(3), var(obj.C));
%             obj.verifyEqual(s.variance(23), var(obj.D));
            
            obj.verifyEqual(s.med(1), median(obj.A));
            obj.verifyEqual(s.med(2), median(obj.B));
            obj.verifyEqual(s.med(3), median(obj.C));
%             obj.verifyEqual(s.med(23), median(obj.D));
            
            obj.verifyEqual(s.standDev(1), std(obj.A));
            obj.verifyEqual(s.standDev(2), std(obj.B));
            obj.verifyEqual(s.standDev(3), std(obj.C));
%             obj.verifyEqual(s.standDev(23), std(obj.D));

        end
    end
    
end

