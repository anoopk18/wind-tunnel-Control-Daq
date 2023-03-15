function ObjStepper = InitTraverse(ComPort)
% ComPort , a string like 'COM3'
% NumAxis , a scalar, 1 for just x axis motion, 2 for x and y axis
% Vel     , a scalar or a vector, depending on the number of axis used.
%           default is 2000 steps/sec.


% this function opens serial communication port and sets up all the 
% configuration to be used with stepper motors.

delete(instrfind({'ComPort'},{'COM5'}));
instrreset

ObjStepper = serialport("COM5", 9600,"Parity","none","ByteOrder","little-endian","DataBits",8,"FlowControl","none","StopBits",1,"Timeout",10); 

fprintf(ObjStepper,'%s\r','@03');



