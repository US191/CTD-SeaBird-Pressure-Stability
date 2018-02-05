
function readXmlFile

properties
filename
%Class constructor
    function obj = readXmlFile (varargin)
        
        obj.filename = varargin{1};
        
    end


%Read file xml
file = xmlread(obj.filename);

%Structure for recover coefficient of calibration
name = {'CalibrationDate','SerialNumber','C1','C2','C3','D1',...
    'D2','T1','T2','T3','T4','Slope','Offset','T5','AD590M','AD590B'};

coefficients = {''};

s = struct('name_element', name, 'coeff', coefficients);

for i = 1:16
    element = file.getElementsByTagName(s(i).name_element);
    s(i).coeff = char(element.item(0).getFirstChild.getData);
    disp(s(i).coeff);
end

end




