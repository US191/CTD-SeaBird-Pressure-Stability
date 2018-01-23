
classdef configD < handle
    
    %     properties
    
    %     end
    
    methods (Static)
        
        function get_coeff
            
            %Read file xml
            file = xmlread('1263.xml');
            
            %Structure
            field1 = 'name_element';
            name = {'CalibrationDate','SerialNumber','C1','C2','C3','D1',...
                'D2','T1','T2','T3','T4','Slope','Offset','T5','AD590M','AD590B'};
            
            field2 = 'coeff';
            coefficients = {''};
            
            s = struct(field1, name, field2, coefficients);
            
            for i = 1:16
                element = file.getElementsByTagName(s(i).name_element);
                s(i).coeff = char(element.item(0).getFirstChild.getData);
                
            end
            disp(s(15).coeff)
            
        end
        
    end
end