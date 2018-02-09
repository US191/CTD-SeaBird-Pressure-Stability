classdef decode < handle
    
    properties
        trame = '106B570ACF6883646910BA460A87706DEFFF882FFFFFFFFFFFFFFF000000719241';
        nb_freq = 5;        %number of frequency
        size_freq = 6;      %6 bytes per hex freq
        f = ones(nb_freq,1) %get frequency value
        p=1;                %Location trame
        
    end
    
    properties
        nb = [];            %nb all parameters
    end
    
    methods
        %class trame constructor
        function obj = decode(trame)
            obj.trame = trame ;
            obj.setFreq;
            for i = 1:1:obj.nb
                bytes = obj.trame(p:p + obj.nb);
                switch nb
                    case 'nb_freq'
                        
                        obj.f(i) = decodef(bytes);
                        obj.p = p + size_freq;
                end
                
            end
        end
        
        %Create an dimension instance
        function dim(obj)
            set(obj.nb, 'nb_freq', obj.nb_freq)
        end
        
        %set nb_frequency
        function setFreq(obj, nb_freq)
            switch nb_freq
                case {1, 2, 3, 4, 5}
                    obj.nb_freq = nb_freq;
                    
                otherwise
                    error('matlab:invalidnbfreq','MATLAB:invalid number frequency: %d', nb_freq);
            end
        end
        
        %get nb_frequency
        function nb_freq = getFreq(obj)
            nb_freq = obj.nb_freq;
        end
        
        %Calcul frequency
        function decodef(obj, bytes)
            
            obj.f = hex2dec([bytes(1:2);bytes(3:4);bytes(5:6)]);
            obj.f = obj.f(1)*256 + obj.f(2) + obj.f(3)/256;
        end
        
        
        
    end
    
end
