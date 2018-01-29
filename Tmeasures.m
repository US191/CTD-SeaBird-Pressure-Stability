
classdef Tmeasures < trame
    
    %     properties
    
    %     end
    
    methods (Static)
        
        function coeff_filexml
            
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
            %             disp(s(15).coeff)
            
        end
        
        function calcul_data
            
            %Pressure temperature compensation
            Td = (s(15).coeff*N_dec)-s(16).coeff;
            
            %Calcul Pressure (psia)
            C = s(3).coeff + s(4).coeff*Td + s(5).coeff*Td^2;
            D = s(6).coeff + s(7).coeff*Td;
            T = 1/f_pressure;
            To = s(8).coeff + s(9).coeff*Td + s(10).coeff*Td^2 + ...
                s(11).coeff*Td^3 + s(14).coeff*Td^4;
            
            Pressure = C*(1-(To^2/T^2))*(1-D*(1-(To^2/T^2)));
            
            
            
        end
        
%         function stat
%             
%             
%         end
        
    end
end