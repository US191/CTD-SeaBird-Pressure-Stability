function [ v ] = save_volt(bit,j)

data_v = bit(j:j+2);

byte = [data_v(1),data_v(2),data_v(3)];

byte_dec = hex2dec(byte);

v = 5*(1-(byte_dec/4095));

end