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

## Serial class on Windows

### The base class is us191.serial

```matlab
>> us191.serial.Discover

ans =

  4×1 cell array

    {'COM3' }
    {'COM9' }
    {'COM11'}
    {'COM12'}

s = us191.serial('COM9','baudrate',4800,'terminator','CR/LF') 
s = 

  Port:       'COM9'
  BaudRate:   4800
  DataBits:   8
  StopBits:   1
  Parity:     'none'
  Terminator: 'CR/LF'
  Status:     'not connected'
  Echo:       'false'

s = 

  Port:       'COM9'
  BaudRate:   4800
  DataBits:   8
  StopBits:   1
  Parity:     'none'
  Terminator: 'CR/LF'
  Status:     'open'
  Echo:       'false'

list of methods

Methods for class us191.serial:

close                getParity            open                 setParity            
disp                 getPort              serial               setPort              
getBaudRate          getStatus            setBaudRate          setStopBits          
getDataBits          getStopBits          setDataBits          setTerminator        
getEcho              getTerminator        setEcho              

Static methods:

Discover             getAvailableComPort  

Methods of us191.serial inherited from handle.
```    
Open the serial port, status must be 'open'. The serial port class use an event 'sentenceAvailable' to notify when a valid sentence terminated with 'Terminator' character(s) was received, eg 'CR/LF' for a GPS NMEA183.
To see the valid sentences, you can set private property 'echo' to 'true' in constructor function or use set.Echo(true) function:
```matlab
s = us191.serial('COM9','baudrate',4800,'terminator','CR/LF','echo',true) 
>> s.open
>> s.open
Recu: $GPGGA,091512.553,4821.5783,N,00433.5824,W,1,06,2.8,70.1,M,52.2,M,,0000*75
Recu: $GPGSA,A,3,03,07,22,23,09,17,,,,,,,3.7,2.8,2.5*31
Recu: $GPRMC,091512.553,A,4821.5783,N,00433.5824,W,0.88,321.52,120118,,,A*74
Recu: $GPGGA,091513.553,4821.5744,N,00433.5764,W,1,06,2.8,79.0,M,52.2,M,,0000*7C
Recu: $GPGSA,A,3,03,07,22,23,09,17,,,,,,,3.7,2.8,2.5*31
Recu: $GPRMC,091513.553,A,4821.5744,N,00433.5764,W,0.66,327.63,120118,,,A*71
Recu: $GPGGA,091514.553,4821.5729,N,00433.5744,W,1,06,2.8,81.1,M,52.2,M,,0000*74
Recu: $GPGSA,A,3,03,07,22,23,09,17,,,,,,,3.7,2.8,2.5*31
Recu: $GPRMC,091514.553,A,4821.5729,N,00433.5744,W,0.54,329.36,120118,,,A*70
Recu: $GPGGA,091515.553,4821.5725,N,00433.5744,W,1,06,2.8,81.0,M,52.2,M,,0000*78
>> s.close
```    
### Inherited class gps

This class defined a listener as:
```matlab
 obj.listenerHandle = addlistener(obj,'sentenceAvailable',@obj.handleEvnt)
```    
This listener wait for the notification ''sentenceAvailable' that notify a valid sentence was receive and the handleEvnt function decode NMEA sentence and save data in private properties.
The read function display the last available data and call open function if the serail port was 'closed'.

```matlab
>> s=us191.gps('COM9')

s = 

  Port:       'COM9'
  BaudRate:   4800
  DataBits:   8
  StopBits:   1
  Parity:     'none'
  Terminator: 'CR/LF'
  Status:     'not connected'
  Echo:       'true'

>> s.read
Time:  92422 Lat: 48.35984 Long:  -4.55978
>> s.close
```    

## Serial class on Linux

Under Linux, you must specify Java Startup Options to see serial port with Matlab.

Create the file java.opts under /usr/local/MATLAB/R2017b/bin/glnxa64

with the following line :
```bash    
  -Dgnu.io.rxtx.SerialPorts=/dev/ttyS4:/dev/ttyUSB0
```    
Use the 'ls /dev/tty*' command to discover the new serail port.

Add the user to dialer group and change /dev/ttyUSB0 permission to 777


```matlab
>> us191.serial.Discover

ans =

  2×1 cell array

    {'/dev/ttyS4'  }
    {'/dev/ttyUSB0'}

>> s=us191.gps('/dev/ttyUSB0','baudrate',4800,'terminator','CR/LF')
...

```    


 Autor: Pierre Rousselot - Jacques Grelet - Morganne Domenge
 Date: 05-2016_01-2017
