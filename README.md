# Study the SeaBird pressure sensor stability

## Input

- .txt SeaBird report file
- .cnv file with pressure temperature in column 1
- .hdr file with pressure frequency take on the deck before and after profile

## Different steps

- Recovery of the pressure sensor calibration coefficient
- Recovery of the pressure sensor temperature at the beginning/end of the profile
- Recovery of the pressure frequency before and after the profile (on the deck)
- Calculate and compare start/end profile pressure value (if NaN, no frequency value)

## Serial class

```matlab
s = us191.gps('COM9')
s  

```    


 _Autor: Pierre Rousselot_Jacques Grelet
 _Date: 05-2016_01-2017
