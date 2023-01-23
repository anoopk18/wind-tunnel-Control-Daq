clear
close all

% Ronan Gissler January 2023

% This file is used to analyze the data from the experiments Sakthi
% and I ran with the 1 DOF flapper robot with and without
% Polydimethylsiloxane (PDMS) wings on January 19th 2023. We tested
% flapping speeds between 1 Hz and 4 Hz with the PDMS wings, at 4 Hz
% the whole system was shaking and grinding loudly. We test flapping
% speeds between 1 Hz and 6 Hz with no wings attached, at 6 Hz the
% whole system was shaking and grinding loudly (although less
% dramatically than at 4 Hz with the wings attached).

%%

% ----------------------------------------------------------------
% ------------------------Plot All Data---------------------------
% ----------------------------------------------------------------

files = ["1Hz_body_experiment_011923.csv"
         "2Hz_body_experiment_011923.csv"
         "3Hz_body_experiment_011923.csv"
         "4Hz_body_experiment_011923.csv"
         "5Hz_body_experiment_011923.csv"
         "6Hz_body_experiment_011923.csv"
         "1Hz_PDMS_experiment_011923.csv"
         "2Hz_PDMS_experiment_011923.csv"
         "3Hz_PDMS_experiment_011923.csv"
         "4Hz_PDMS_experiment_011923.csv"];

for i = 1:length(files)
    % Get case name from file name
    case_name = erase(files(i), "_experiment_011923.csv");
    case_name = strrep(case_name,'_',' ');
    
    % Get data from file
    data = readmatrix(files(i));

    times = data(1:end,1);
    force_vals = data(1:end,2:7);

    % Trimming off end of data (it appears beginning is already
    % trimmed)
    count = 0;
    vertical_diffs = diff(force_vals(:,3));
    for j = 1:length(vertical_diffs)
        if (abs(vertical_diffs(j)) < 0.05)
            count = count + 1;
        else
            count = 0;
        end
        if (count > 5)
            data = data(1:j-1000, :);
            break
        end
    end

    times = data(1:end,1);
    force_vals = data(1:end,2:7);

    force_means = round(mean(force_vals), 3);
    force_SDs = round(std(force_vals), 3);
    
    % Open a new figure.
    f = figure;
    f.Position = [200 50 900 560];

    % Create three subplots to show the force time histories. 
    subplot(2, 3, 1);
    plot(times, force_vals(:, 1));
    title(["F_x" ("avg: " + force_means(1) + " SD: " + force_SDs(1))]);
    xlabel("Time (s)");
    ylabel("Force (N)");
    subplot(2, 3, 2);
    plot(times, force_vals(:, 2));
    title(["F_y" ("avg: " + force_means(2) + " SD: " + force_SDs(2))]);
    xlabel("Time (s)");
    ylabel("Force (N)");
    subplot(2, 3, 3);
    plot(times, force_vals(:, 3));
    title(["F_z" ("avg: " + force_means(3) + " SD: " + force_SDs(3))]);
    xlabel("Time (s)");
    ylabel("Force (N)");

    % Create three subplots to show the moment time histories.
    subplot(2, 3, 4);
    plot(times, force_vals(:, 4));
    title(["M_x" ("avg: " + force_means(4) + " SD: " + force_SDs(4))]);
    xlabel("Time (s)");
    ylabel("Torque (N m)");
    subplot(2, 3, 5);
    plot(times, force_vals(:, 5));
    title(["M_y" ("avg: " + force_means(5) + " SD: " + force_SDs(5))]);
    xlabel("Time (s)");
    ylabel("Torque (N m)");
    subplot(2, 3, 6);
    plot(times, force_vals(:, 6));
    title(["M_z" ("avg: " + force_means(6) + " SD: " + force_SDs(6))]);
    xlabel("Time (s)");
    ylabel("Torque (N m)");
    
    % Label the whole figure.
    sgtitle("Force Transducer Measurement for " + case_name);
    
    case_parts = char(split(case_name));
    save([case_parts(2,:),'_',case_parts(1,1:end-1),'.mat'], 'data')
end

%%

% ----------------------------------------------------------------
% -------------------------Plot PDMS Data-------------------------
% ----------------------------------------------------------------
     
cases = ["PDMS_1Hz", "PDMS_2Hz", "PDMS_3Hz", "PDMS_4Hz"];

% Open a new figure.
f = figure;
f.Position = [200 50 900 560];
title("Lift Force (z-direction)");
xlabel("Time (s)");
ylabel("Force (N)");
hold on

for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');

    % Trimming off end of data (it appears beginning is already
    % trimmed) when differences between measurements are small
    count = 0;
    vertical_diffs = diff(data(:,4));
    for j = 1:length(vertical_diffs)
        if (abs(vertical_diffs(j)) < 0.05)
            count = count + 1;
        else
            count = 0;
        end
        if (count > 5)
            data = data(1:j-1000, :);
            break
        end
    end
    
    % resave data after trimming it
    save(cases(i) + ".mat", 'data')

    times = data(1:end,1);
    force_vals = data(1:end,2:7);
    
    % Plot lift force
    plot(times, force_vals(:, 3), 'DisplayName', case_name, "LineWidth",3);
end
legend("Location","Southwest");
ax1 = axes('Position',[0.35 0.2 0.2 0.2]);
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');

    times = data(1:end,1);
    force_vals = data(1:end,2:7);
    
    % Plot lift force
    plot(ax1, times, force_vals(:, 3))
end
xlim([28, 38])
ylim([-16, 16])
box on
annotation('arrow',[0.45 0.39], [0.4 0.52])

% The data shows a positive correlation between wingbeat frequency and
% aerodynamic force, with the exception of 1 Hz. This exception is
% explained by the fact that the robot's natural frequency appeared to
% lie around 1 Hz so the system vibrated loudly for the 1 Hz test,
% obscuring the aerodynamic force production. 

%%

% ----------------------------------------------------------------
% ----------------------Plot Wingless Data------------------------
% ----------------------------------------------------------------
     
cases = ["Body_1Hz", "Body_2Hz", "Body_3Hz", ...
         "Body_4Hz", "Body_5Hz", "Body_6Hz"];

% Open a new figure.
f = figure;
f.Position = [200 50 900 560];
title("Lift Force (z-direction)");
xlabel("Time (s)");
ylabel("Force (N)");
hold on

for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');

    % Trimming off end of data (it appears beginning is already
    % trimmed)
    count = 0;
    vertical_diffs = diff(data(:,4));
    for j = 1:length(vertical_diffs)
        if (abs(vertical_diffs(j)) < 0.05)
            count = count + 1;
        else
            count = 0;
        end
        if (count > 5)
            data = data(1:j-1000, :);
            break
        end
    end

    % resave data after trimming it
    save(cases(i) + ".mat", 'data')
    
    times = data(1:end,1);
    force_vals = data(1:end,2:7);
    
    % Plot lift force
    plot(times, force_vals(:, 3), 'DisplayName', case_name, "LineWidth",3);
end
legend("Location","Southwest");

%%

% ----------------------------------------------------------------
% -------Plot PDMS and Wingless Data at 1 Hz, 2 Hz, and 3 Hz------
% ----------------------------------------------------------------
     
cases = ["PDMS_1Hz", "PDMS_2Hz", "PDMS_3Hz"];

% Open a new figure.
f = figure;
f.Position = [200 50 900 560];
subplot(1,2,1)
title("PDMS Wings");
xlabel("Time (s)");
ylabel("Force (N)");
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');

    times = data(1:end,1);
    force_vals = data(1:end,2:7);
    
    % Plot lift force
    plot(times, force_vals(:, 3), 'DisplayName', case_name, "LineWidth",3);
end
legend("Location","Southwest");

%-------------------------Body Only Plot-----------------------------
cases = ["Body_1Hz", "Body_2Hz", "Body_3Hz"];

subplot(1,2,2)
title("Body Only");
xlabel("Time (s)");
ylabel("Force (N)");
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');

    times = data(1:end,1);
    force_vals = data(1:end,2:7);
    
    % Plot lift force
    plot(times, force_vals(:, 3), 'DisplayName', case_name, "LineWidth",3);
end
legend("Location","Southwest");
sgtitle("Lift Force (z-direction)");

%%

% ----------------------------------------------------------------
% -------Plot PDMS and Wingless Data at 1 Hz, 2 Hz, and 3 Hz------
% -------------------normalized by wing cycles--------------------
% ----------------------------------------------------------------
     
cases = ["PDMS_1Hz", "PDMS_3Hz", "PDMS_2Hz"];

% Open a new figure.
f = figure;
f.Position = [200 50 900 560];
subplot(1,2,1)
title("PDMS Wings");
xlabel("Wingbeat Number");
ylabel("Force (N)");
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');

    times = data(1:end,1);
    force_vals = data(1:end,2:7);

    % Filtering force data with moving average filter
    window = 100;
    b = 1/window*ones(window,1);
    filtered_lift_vals = filter(b, 1, force_vals(:, 3));
    
    % Count the number of wingbeats
    wingbeat_count = 0;
    case_name = char(case_name);
    speed = str2double(case_name(6));
    window = round(400 / speed);
    start_index = 0;
    end_index = 0;
    for j = (1 + window):(length(filtered_lift_vals) - window)
        if (filtered_lift_vals(j) == max(filtered_lift_vals(j-window:j+window)))
            wingbeat_count = wingbeat_count + 1;
            if (start_index == 0)
                start_index = j;
            else
                end_index = j;
            end
        end
    end
    
    data = data(start_index:end_index,:);
    filtered_lift_vals = filtered_lift_vals(start_index:end_index);
    wingbeats = linspace(0,wingbeat_count,length(filtered_lift_vals));

    disp(wingbeat_count)
    disp(length(filtered_lift_vals))
    
    force_vals = data(1:end,2:7);
    % Plot lift force
    plot(wingbeats, force_vals(:,3), 'DisplayName', case_name, "LineWidth",3);
    save(cases(i) + ".mat", 'data', 'filtered_lift_vals','wingbeats');
end
legend("Location","Southwest");
ax1 = axes('Position',[0.15 0.26 0.2 0.2]);
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name,'data','wingbeats');
    
    force_vals = data(1:end,2:7);
    
    % Plot lift force
    plot(ax1, wingbeats, force_vals(:,3));
end
xlim([0, 3])
ylim([-3, 3])
y_axis = line(xlim, [0 0], 'Color','black');
box on
annotation('arrow',[0.25 0.14], [0.46 0.52])

%-------------------------Body Only Plot-----------------------------
cases = ["Body_1Hz", "Body_3Hz", "Body_2Hz"];

subplot(1,2,2)
title("Body Only");
xlabel("Wingbeat Number");
ylabel("Force (N)");
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');

    times = data(1:end,1);
    force_vals = data(1:end,2:7);

    % Filtering force data with moving average filter
    window = 100;
    b = 1/window*ones(window,1);
    filtered_lift_vals = filter(b, 1, force_vals(:, 3));
    
    % Count the number of wingbeats
    wingbeat_count = 0;
    case_name = char(case_name);
    speed = str2double(case_name(6));
    window = round(400 / speed);
    start_index = 0;
    end_index = 0;
    for j = (1 + window):(length(filtered_lift_vals) - window)
        if (filtered_lift_vals(j) == max(filtered_lift_vals(j-window:j+window)))
            wingbeat_count = wingbeat_count + 1;
            if (start_index == 0)
                start_index = j;
            else
                end_index = j;
            end
        end
    end
    
    data = data(start_index:end_index,:);
    filtered_lift_vals = filtered_lift_vals(start_index:end_index);
    wingbeats = linspace(0,wingbeat_count,length(filtered_lift_vals));

    disp(wingbeat_count)
    disp(length(filtered_lift_vals))
    
    force_vals = data(1:end,2:7);
    % Plot lift force
    plot(wingbeats, force_vals(:,3), 'DisplayName', case_name, "LineWidth",3);
    save(cases(i) + ".mat", 'data', 'filtered_lift_vals','wingbeats');
end
legend("Location","Southwest");
ax2 = axes('Position',[0.6 0.26 0.2 0.2]);
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name,'data','wingbeats');

    force_vals = data(1:end,2:7);
    
    % Plot lift force
    plot(ax2, wingbeats, force_vals(:,3));
end
xlim([0, 3])
ylim([-3, 3])
y_axis = line(xlim, [0 0], 'Color','black');
box on
annotation('arrow',[0.7 0.58], [0.46 0.48])

sgtitle("Lift Force (z-direction)");

%%

% ----------------------------------------------------------------
% -------Plot PDMS and Wingless Data at 1 Hz, 2 Hz, and 3 Hz------
% -------------normalized by wing cycles and filtered-------------
% ----------------------------------------------------------------
     
cases = ["PDMS_3Hz", "PDMS_2Hz", "PDMS_1Hz"];

% Open a new figure.
f = figure;
f.Position = [200 50 900 560];
subplot(1,2,1)
title("PDMS Wings");
xlabel("Wingbeat Number");
ylabel("Force (N)");
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');

    % Plot lift force
    plot(wingbeats, filtered_lift_vals, 'DisplayName', case_name, "LineWidth",3);
end
legend("Location","Southwest");
ax1 = axes('Position',[0.15 0.26 0.2 0.2]);
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name,'filtered_lift_vals','wingbeats');
    
    % Plot lift force
    plot(ax1, wingbeats, filtered_lift_vals);
end
xlim([0, 3])
ylim([-3, 3])
y_axis = line(xlim, [0 0], 'Color','black');
box on
annotation('arrow',[0.25 0.14], [0.46 0.52])

%-------------------------Body Only Plot-----------------------------
cases = ["Body_3Hz", "Body_2Hz", "Body_1Hz"];

subplot(1,2,2)
title("Body Only");
xlabel("Wingbeat Number");
ylabel("Force (N)");
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name);
    
    case_name = strrep(cases(i),'_',' ');
    
    % Plot lift force
    plot(wingbeats, filtered_lift_vals, 'DisplayName', case_name, "LineWidth",3);
end
legend("Location","Southwest");
ax2 = axes('Position',[0.6 0.26 0.2 0.2]);
hold on
for i = 1:length(cases)
    % Load data
    mat_name = cases(i) + ".mat";
    load(mat_name,'filtered_lift_vals','wingbeats');

    % Plot lift force
    plot(ax2, wingbeats, filtered_lift_vals);
end
xlim([0, 3])
ylim([-3, 3])
y_axis = line(xlim, [0 0], 'Color','black');
box on
annotation('arrow',[0.7 0.58], [0.46 0.48])

sgtitle(["Filtered Lift Force (z-direction)" "Moving Average Filter (Window = 100 ms)"]);

%%

% ----------------------------------------------------------------
% -------Plot Wingless Data Subtracted from PDMS Data-------------
% ---------------------at 1 Hz, 2 Hz, and 3 Hz--------------------
% ----------------------------------------------------------------

load Lift_body_1Hz.mat;
Lift_body_1Hz = filtered_lift_vals;
load Lift_body_2Hz.mat;
Lift_body_2Hz = filtered_lift_vals;
load Lift_body_3Hz.mat;
Lift_body_3Hz = filtered_lift_vals;

load Lift_PDMS_1Hz.mat;
Lift_PDMS_1Hz = filtered_lift_vals;
wingbeats_PDMS_1Hz = wingbeats;
load Lift_PDMS_2Hz.mat;
Lift_PDMS_2Hz = filtered_lift_vals;
wingbeats_PDMS_2Hz = wingbeats;
load Lift_PDMS_3Hz.mat;
Lift_PDMS_3Hz = filtered_lift_vals;
wingbeats_PDMS_3Hz = wingbeats;

min_length = min(length(Lift_body_1Hz), length(Lift_PDMS_1Hz));
Lift_sub_1Hz = Lift_PDMS_1Hz(1:min_length) - Lift_body_1Hz(1:min_length);
wingbeats_sub_1Hz = wingbeats_PDMS_1Hz(1:min_length);

min_length = min(length(Lift_body_2Hz), length(Lift_PDMS_2Hz));
Lift_sub_2Hz = Lift_PDMS_2Hz(1:min_length) - Lift_body_2Hz(1:min_length);
wingbeats_sub_2Hz = wingbeats_PDMS_2Hz(1:min_length);

min_length = min(length(Lift_body_3Hz), length(Lift_PDMS_3Hz));
Lift_sub_3Hz = Lift_PDMS_3Hz(1:min_length) - Lift_body_3Hz(1:min_length);
wingbeats_sub_3Hz = wingbeats_PDMS_3Hz(1:min_length);

% Open a new figure.
f = figure;
f.Position = [200 50 900 560];
hold on
plot(wingbeats_sub_3Hz, Lift_sub_3Hz, 'DisplayName', '3 Hz', "LineWidth",3);
plot(wingbeats_sub_2Hz, Lift_sub_2Hz, 'DisplayName', '2 Hz', "LineWidth",3);
plot(wingbeats_sub_1Hz, Lift_sub_1Hz, 'DisplayName', '1 Hz', "LineWidth",3);
xlabel("Wingbeat Number");
ylabel("Force (N)");
title(["Aerodynamic Force Production" "(Subtracting Force without Wings from Force with Wings)"]);
legend("Location","Southwest");
ax1 = axes('Position',[0.15 0.3 0.2 0.2]);
hold on
plot(ax1, wingbeats_sub_3Hz, Lift_sub_3Hz, "LineWidth",2);
plot(ax1, wingbeats_sub_2Hz, Lift_sub_2Hz, "LineWidth",2);
plot(ax1, wingbeats_sub_1Hz, Lift_sub_1Hz, "LineWidth",2);
xlim([0, 3])
ylim([-3, 3])
y_axis = line(xlim, [0 0], 'Color','black');
box on
annotation('arrow',[0.25 0.14], [0.5 0.59])


%%

% % ----------------------------------------------------------------
% % ---------------------------Trashed Code-------------------------
% % ----------------------------------------------------------------
% 
% % Fast Fourier Transform stuff I was looking at for a bit...
% 
% % f = figure;
% % f.Position = [200 50 900 560];
% % %instfreq(force_vals(:, 3),fs)
% % Y = fft(force_vals(:, 3));
% % L = 2000;
% % P2 = abs(Y/L);
% % P1 = P2(1:L/2+1);
% % P1(2:end-1) = 2*P1(2:end-1);
% % 
% % freqs = fs*(0:(L/2))/L;
% % plot(freqs,P1) 
% % title("Single-Sided Amplitude Spectrum of Force Transdcuer Data")
% % xlabel("f (Hz)")
% % ylabel("|P1(f)|")
% % xlim([0,10])
% 
% % instantaneous frequency stuff I was trying...
% 
% % Open a new figure.
% f = figure;
% f.Position = [200 50 900 560];
% title("Instantaneous Frequency of Force in z-direction");
% xlabel("Time (s)");
% ylabel("Force Frequency i.e. Wing Speed (Hz)");
% hold on
% 
% for i = 1:length(files)
%     % Get case name from file name
%     case_name = erase(files(i), ["12_02_2022_benchtop_test/", "_experiment_120222.csv"]);
%     case_name = strrep(case_name,'_',' ');
%     
%     % Get data from file
%     data = readmatrix(files(i));
% 
%     times = data(1:end,1);
%     force_vals = data(1:end,2:7);
%     
%     % Filtering force transducer data with a butterworth filter
%     fc = 3; % cutoff frequency
%     fs = 1000; % sample frequency
% 
%     [b,a] = butter(6,fc/(fs/2)); % 6th order
%     force_vals = filter(b, a, force_vals);
% 
% %     [s,f,t] = stft(force_vals(:, 3),fs);
% %     stft(s(64,:),fs);
% %     force_vals(:, 3) = force_vals(:, 3) - mean(force_vals(:, 3));
% %     stft(force_vals(:, 3),fs,'Window',kaiser(1024,5),'OverlapLength',500,'FFTLength',1024, 'FrequencyRange','centered');
% 
% %     pspectrum(force_vals(:, 3),fs,'spectrogram');
% %     ylim([0,10]);
% 
%     [ifq,t] = instfreq(force_vals(:, 3),fs);
%     
%     % Filtering instantaneous frequency with a butterworth filter
%     window = 100;
%     b = 1/window*ones(window,1);
%     ifq = filter(b, 1, ifq);
%     
%     plot(t, ifq, 'DisplayName', case_name, "LineWidth", 3)
% end
% legend("Location","Southwest");