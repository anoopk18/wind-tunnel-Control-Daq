function  i_err_flag = AcqDataFcn_v2(s,m,n,i_data_flag,n_err)

% flag for taking data or just pause the traverse for certain amount of time
    if i_data_flag == 1 
        
        %% preconditioning
    
        % run number
        num_run = s.num_run;
        % Data acquisition duration
        t_data_acqu = s.t_data_acqu;         % [seconds]
        % Daq aqusition rate
        sample_rate = s.sample_rate;       % [Hz]       
        % Freestream velocity
        test_speed = s.test_speed;             % [m/s]
        % Save date of the experiment
        test_date = s.test_date;    
        % Bit of Daq port used
        BitOfDaq = s.BitOfDaq;
        % Put whatever additional information here as comment, which will be saved and subsequently
        % could be read as [filename].comment later on.
        
        savePath = s.savePath;
        distX = s.distX;
        distY = s.distY;
    end

end

