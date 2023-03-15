clear all; close all; clc
%{
Author: Xiaozhou Fan @ Brown University 
Email: xzfan@brown.edu
Edited: Anoop Kiran [3/15/2023] (ajkiran@brown.edu)
%}

%{
Note1: Kindly ensure that the device connnected is Windows 10 or lower...
Unfortunately, the traverse doesn't configure with other models

Note2: Use device manager to detect the ComPort at which the desktop is
connect and make that adjustment for "COMx" in the code

Note3: Enter your savepath to save the files in the correct allocation
folder
%}

% Purpose of this code: Prescribing traverse motion in x and y axes

%Closes communication channel with linear actuators as initialization step
delete(instrfind({'ComPort'},{'COM5'}));

%% User input parameters
                        
i_acqData = 1;          %also acquire data at each grid or just traverse

distX = input(' Please input the horizontal distance[cm] dx between two grids: \n');             
distY = input(' Please input the vertical distance[cm] dy between two grids: \n');     

nx = input(' Total number of grid along X direction: \n');                 %number of grid points in x direction
ny = input(' Total number of grid along Y direction: \n');                 %number of grid points in y direction
stepsPerCM = 822   ;         %resolution of stepper motor resol = length ( cm ) / step
vx = 1500; vy = 1500;   %velocity of actuators in steps/sec in X,Y axis respectively
ComPort = 'COM5';       %the port number of the traverse system
NumAxis = 2;
                        

%settings for the data acquistion
                         
% s is a struct that stores all the information about this experiment
% run number
s.num_run = input(' What is the run number for this experiment: \n');
% Data acquisition duration
s.t_data_acqu = input(' For each grid point, the sample time [second] is: \n');        % [seconds]
% Daq aqusition rate
s.sample_rate = 10000;       % [Hz]       
% Freestream velocity
s.test_speed = input(' The freestream is supposed to be [m/s]: \n');            % [m/s]
% Save date of the experiment
s.test_date = date;    
% Bit of Daq port used
s.BitOfDaq = 2^16;

s.distX = distX;
s.distY = distY;

%specify path to save data
s.savePath = '.\DataRepo\5_7_2019\1run_7ms_46by15_1.5,5cm_20sec';

s.std_thres(1) = .5;        % full signal critical std
s.std_thres(2) = .5;         % ac signal critical std
s.std_thres(3) = .5;        % pressure signal critical std

fprintf('Confirm that the threshold for error data are [fl/ac/pitot]:\n %4.3f,%4.3f,%4.3f \n',s.std_thres)
%pause;

max_redo = input('In the possible event of err in measurement, input number of times to retake: \n');                   % maximum number of times to retake the data if error occurred

mat_err_ij = nan(nx,ny);        % used to denote where error is consistent after max_redo trials

%% Derivatives

%Change file path to the folder in which all the relevant MATLAB files are located
delete(instrfindall)        %Closes any open instrument controller channels
stepper = InitTraverse(ComPort);   %Initiates the linear actuator controllers

stepsX = distX*stepsPerCM;     %Converts inches between grid points into # of steps
stepsY = distY*stepsPerCM;     %Converts inches between grid points into # of steps
runtimeX = stepsX/vx+6;  %Calculates how long it will take the actuators to move between steps,
runtimeY = stepsY/vy+6;  %and adds 1 second to that time to allow vibrations to damp out.


%% Commencing traverse and data acquisition (and save)

fprintf('Is the save path for each grid data correct [ Press any key to continue]:\n %s ? \n\n',s.savePath)
pause;
fprintf('Please fire up AeroWare to record the evolution of temperature etc !! \n\n')
pause;
fprintf('Commencing action ...')

h_ind = 1;  %Horizontal index, used for accurate indexing, accounting for zig-zagging path of the actuators.

%Collect the first data point, in the upper left corner of the grid
disp('Initial Postion grid (1,1)')

%Iterate through nx x ny grid points, collecting data after each move. 
for n = 1:ny
    %Y axis moves down after each X row is complete 
    if n~=1 %Doesn't move when n=1, so data is collected on first row
        fprintf('Traversing in y direction (towards motor) for %.2f cm \n',distY)
        temp  = ['@0A',' ','0',',','30',',',num2str(-stepsY),',',num2str(vy)];
        fprintf(stepper,'%s\r',temp); pause(runtimeY);        

    end

    %Data collection for increments in x-direction (switching direction of
    %actuator motion with each row)
    for m = 1:nx-1
        if mod(n,2)==1 %n is odd
            fprintf('Traversing in x for %.2f cm (towards motor)\n',distX)
            temp  = ['@0A',' ',num2str(-stepsX),',',num2str(vx),',','0',',','30'];
            fprintf(stepper,'%s\r',temp); pause(runtimeX);
            fprintf('Done traversing!\n\n')

            h_ind = h_ind+1; %When actuator moves to the right, horizontal index increments up

        else %n is even
            fprintf('Traversing in x for -%.2f cm (away from motor)\n',distX)
            temp  = ['@0A',' ',num2str(stepsX),',',num2str(vx),',','0',',','30'];
            fprintf(stepper,'%s\r', temp); pause(runtimeX);
            fprintf('Done traversing!\n\n')

            h_ind = h_ind-1; %When actuator moves to the left, horizontal index increments down

        end
    end

end


% after the end of the traverse, go back to its original position

%{
if the number of travesing step in y is odd and y is not 1, then to
travese back to original position, we need to travese upwards and
leftwards; otherwise, only upwards.
%}

% the number of grid in y is odd and y is not 1
if mod(ny,2) == 1 
    
    temp  = ['@0A',' ',num2str( (nx-1) * stepsX),',',num2str(vx),',','0',',','30'];
    fprintf(stepper,'%s\r',temp); %pause(runtimeY);
    
    temp  = ['@0A',' ','0',',','30',',',num2str((ny-1)*stepsY),',',num2str(vy)];
        fprintf(stepper,'%s\r',temp); %pause(runtimeY); 
    
end

% if ny is even, only move upwards to go back
if mod(ny,2) == 0
    
    temp  = ['@0A',' ','0',',','30',',',num2str((ny-1)*stepsY),',',num2str(vy)];
    fprintf(stepper,'%s\r',temp);
    
end

%Closes communication channel with linear actuators
delete(instrfindall)


