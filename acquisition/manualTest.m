% test from deck-unit
mc = compute('tests/1209.xml');
md = decode;
raw = md.decodeTrame('106B570ACF6883646910BA460A87706DEFFF882FFFFFFFFFFFFFFF000000719241');
fprintf(1, 'freq = %9.3fhz,  rawTemp = %4d,  modulo = %03d\n',raw.frequencies(3), ...
  raw.pressureTemperature, raw.modulo);
t = mc.computeTemp(raw.pressureTemperature);
p = mc.computePress(raw.frequencies(3), t);
fprintf(1, 'Press= %8.3fdb,  Temp= %5.2f°C\n', p, t);
fprintf(1,'\n');

mc = compute('tests/1263.xml');
md = decode;
raw = md.decodeTrame('0C6C77150B2C850F460CBD28148934AB1972E7712F40D02B472FF0000000A3E3FC');
fprintf(1, 'freq = %9.3fhz,  rawTemp = %4d,  modulo = %03d\n',raw.frequencies(3), ...
  raw.pressureTemperature, raw.modulo);
t = mc.computeTemp(raw.pressureTemperature);
p = mc.computePress(raw.frequencies(3), t);
fprintf(1, 'Press= %8.3fdb,  Temp= %5.2f°C\n', p, t);
fprintf(1,'\n');

% fr27001
P = 2.988;
mc = compute('tests/1263.xml');
md = decodeFromFile(5,4,0);
raw = md.decodeTrame('12B788195AD281484A13196918C0A5784563BCB1A508C029118B774150234720B153FCD066B458');
fprintf(1, 'freq = %9.3fhz,  rawTemp = %4d,  modulo = %03d\n',raw.frequencies(3), ...
  raw.pressureTemperature, raw.modulo);
t = mc.computeTemp(raw.pressureTemperature);
p = mc.computePress(raw.frequencies(3), t);
fprintf(1, 'Press= %8.3fdb,  Expected: %8.3f, Temp= %5.2f°C\n', p, P, t);
fprintf(1,'\n')

P = 1653.143;
mc = compute('tests/1263.xml');
md = decodeFromFile(5,4,0);
raw = md.decodeTrame('0C6C77150B2C850F460CBD28148934AB1972E7712F08C068118BA840D02B4720A3E3FC506FB458');
fprintf(1, 'freq = %9.3fhz,  rawTemp = %4d,  modulo = %03d\n',raw.frequencies(3), ...
  raw.pressureTemperature, raw.modulo);
t = mc.computeTemp(raw.pressureTemperature);
p = mc.computePress(raw.frequencies(3), t);
fprintf(1, 'Press= %8.3fdb,  Expected: %8.3f Temp= %5.2f°C\n', p, P, t);
fprintf(1,'\n');

% fr24015
mc = compute('tests/0419.xml');
f = 33394.289; t= 26.21; P=2.650 ;
p = mc.computePress(f,t);
fprintf(1, 'Press= %8.3fdb,  Expected: %8.3f, Temp= %5.2f°C\n', p, P, t);
fprintf(1,'\n');

mc = compute('tests/0419.xml');
f = 34455.074; t = 23.93; P = 2022.451;
p = mc.computePress(f,t);
fprintf(1, 'Press= %8.3fdb,  Expected: %8.3f, Temp= %5.2f°C\n', p, P, t);
fprintf(1,'\n');
