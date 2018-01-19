
% Element nodes — Corresponds to tag names.
% CalibrationDate
% SerialNumber
% C1
% C2
% C3
% D1
% D2
% T1
% T2
% T3
% T4
% Slope
% Offset
% T5
% AD590M
% AD590B

classdef config_deckunit < handle
    
    %     properties
    
    %     end
    
    methods (Static)
        
        function read_para
            
            %Read file xml
            xDoc = xmlread('1263.xml');
            Coeff = {'CalibrationDate';'SerialNumber';'C1';'C2';'C3';'D1';...
                'D2';'T1';'T2';'T3';'T4';'Slope';'Offset';'T5';'AD590M';'AD590B'};
           for i = 1:16
            Elements = xDoc.getElementsByTagName(Coeff(i));
            
            disp(Elements)
           end

        end
        
    end
    
end
