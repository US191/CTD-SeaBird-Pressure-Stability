
classdef config_deckunit < handle
    
    %     properties
    
    %     end
    
    methods (Static)
        
        function read_para
            
            %Read file xml
            file = xmlread('1263.xml');
            Coeff = {'CalibrationDate';'SerialNumber';'C1';'C2';'C3';'D1';...
                'D2';'T1';'T2';'T3';'T4';'Slope';'Offset';'T5';'AD590M';'AD590B'};
            for i = 1:16
                element = file.getElementsByTagName(Coeff(i));
                S = char(element.item(0).getFirstChild.getData);
                disp(S)
            end
            
        end
        
    end
end
