%Function for recover all coefficients of pressure sensor
%Example : coeff = readFileXml('1263.xml')
function coeff = readXmlFile(filename)

%Read file xml
file = xmlread(filename);

%Structure a map object coefficient of calibration
keySet = {'PressureSensor','CalibrationDate','SerialNumber','C1','C2','C3','D1',...
    'D2','T1','T2','T3','T4','Slope','Offset','T5','AD590M','AD590B','PressureSensor'};

for i =1:18
    
    element = file.getElementsByTagName(keySet(i));
    value = element.item(0).getFirstChild.getData;
    valueSet(i) = str2double(value);
end
% disp(keySet);
coeff = containers.Map(keySet, valueSet);

end



