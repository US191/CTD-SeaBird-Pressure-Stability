%READXMLCON get SeaBird pressure sensor coefficients from XML file
% map = readXmlcon(fileName) read an Seabird XML file and return a
% containers.Map object
%
% Example :
%     map = readFileXml('1263.xml')

function map = readXmlcon(filename)

% read file xml
file = xmlread(filename);

% define pressure calibration coefficients name
keySet = {'CalibrationDate','SerialNumber','C1','C2','C3','D1',...
  'D2','T1','T2','T3','T4','Slope','Offset','T5','AD590M','AD590B'};

map = containers.Map('KeyType','char','ValueType','any');
%map = containers.Map;

for k = keySet
  key = char(k);
  element = file.getElementsByTagName(key);
  value = element.item(0).getFirstChild.getData;
  if strcmp( key, 'CalibrationDate')
    map(key) = char(value); % convert java.lang.String to char
  else
    map(key) = str2double(value);
  end
  
end



