function testBlockEdfLoad()
% testBlockEdfLoad. Test function for block EDF load that reads the EDF file
% in three blocks (header, signal header and signal block). Reading the
% signal block in one load allows for matrix rotations to be applied to
% extract all the signals simulteanously. The loader is faster than
% methods that read the signal one entry at a time.
%
% The function is geared towards engineers, whom generally just want the
% signal for analysis. Beyond checking that the file exists, there is very
% little checking.
%
% Function prototype:
%    [header signalHeader signalCell] = blockEdfLoad(edfFN)
%
% Test files:
%     The test files are from the  from the EDF Browser website and the 
% Sleep Heart Health Study (SHHS) (see links below). The first file is
% a generated file and the SHHS file is from an actual sleep study.
%
% Test Descriptions:
%    Test 1: Load and plot generated file
%    Test 2: Incrementally load EDF components
%    Test 3: Return selected signals
%    Test 4: Return selected signals and epochs
%
% ---------------------------------------------
% Dennis A. Dean, II, Ph.D
%
% Program for Sleep and Cardiovascular Medicine
% Brigam and Women's Hospital
% Harvard Medical School
% 221 Longwood Ave
% Boston, MA  02149
%
% File created: October 23, 2012
% Last update:  January 23, 2013 
%    
% Copyright © [2013] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%

% Test Files
edfFn1 = '201434_deidentified.EDF';    % Generated data file


% Test flags
RUN_TEST_1 = 1;  % Load and plot generated file
RUN_TEST_2 = 1;  % Incrementally load EDF components
RUN_TEST_3 = 1;  % Return selected signals
RUN_TEST_4 = 1;  % Return selected signals and epochs

% ------------------------------------------------------------------ Test 1
% Test 1: Load and plot generated file
if RUN_TEST_1 == 1
    % Write test results to console
    testID = 1;
    testStr = 'Load and plot generated file';
    fprintf('----------------------------------------------------------\n');  
    fprintf('Test %.0f. %s\n\n', testID, testStr);
    
    % Echo Status to Console
    fprintf('Load and plot generated file\n\n');    
    
    % Open generated test file
    [header signalHeader signalCell] = blockEdfLoad(edfFn1);

    % Show file contents
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    tmax = 30;

    % Plot First 30 Seconds
    fprintf('\nPlotting first 30 seconds\n\n');
    fig1_2 = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
end

%------------------------------------------------------------------- Test 2
% Test 2: Incrementally load EDF components
if RUN_TEST_2 == 1
    % Write test results to console
    testID = 2;
    testStr = 'Incrementally load EDF components';
    fprintf('----------------------------------------------------------\n');  
    fprintf('Test %.0f. %s\n\n', testID, testStr);  
    
    % Load header, signalHeader and signalCell incrementally
    tic
    header = blockEdfLoad(edfFn1);
    tHeader = toc;
    
    tic
    [header signalHeader] = blockEdfLoad(edfFn1);
    tSignalHeader = toc;

    tic
    [header signalHeader signalCell] = blockEdfLoad(edfFn1);
    tSignalCell = toc;

    % Plot First 30 Seconds
    fprintf('\tTime to Load (header, signalHeader, signalCell) = ');
    fprintf('(%0.3f, %0.3f, %0.3f) (sec)\n\n', tHeader, tSignalHeader, tSignalCell); 
end
%------------------------------------------------------------------- Test 3
% Test 3: Return selected signals
if RUN_TEST_3 == 1
    % Write test results to console
    testID = 3;
    testStr = 'Return selected signals';
    fprintf('----------------------------------------------------------\n');  
    fprintf('Test %.0f. %s\n\n', testID, testStr);  
    
    % Selected Signals
    signalLabels = {'EEG(sec)', 'ECG'}; 
    
    % Load header, signalHeader and signalCell incrementally
    [header signalHeader signalCell] = blockEdfLoad(edfFn1, signalLabels);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    length(signalCell);   
end
%------------------------------------------------------------------- Test 4
% Test 4: Return selected signals and epochs
if RUN_TEST_4 == 1
    % Write test results to console
    testID = 4;
    testStr = 'Return selected signals and epochs';
    fprintf('----------------------------------------------------------\n');  
    fprintf('Test %.0f. %s\n\n', testID, testStr);  
    
    % Selected Signals
    signalLabels = {'EEG(sec)', 'ECG'}; 
    epochs = [10 20]; 
    
    % Load header, signalHeader and signalCell incrementally
    [header signalHeader signalCell] = ...
        blockEdfLoad(edfFn1, signalLabels, epochs);
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    length(signalCell);   

end
end
%-------------------------------------------------- Function PrintEdfHeader
function PrintEdfHeader(header)
    % Write header information to screen
    fprintf('Header:\n');
    fprintf('%30s:  %s\n', 'edf_ver', header.edf_ver);
    fprintf('%30s:  %s\n', 'patient_id', header.patient_id);
    fprintf('%30s:  %s\n', 'local_rec_id', header.local_rec_id);
    fprintf('%30s:  %s\n', ...
        'recording_startdate', header.recording_startdate);
    fprintf('%30s:  %s\n', ...
        'recording_starttime', header.recording_starttime);
    fprintf('%30s:  %.0f\n', 'num_header_bytes', header.num_header_bytes);
    fprintf('%30s:  %s\n', 'reserve_1', header.reserve_1);
    fprintf('%30s:  %.0f\n', 'num_data_records', header.num_data_records);
    fprintf('%30s:  %.0f\n', ...
        'data_record_duration', header.data_record_duration);
    fprintf('%30s:  %.0f\n', 'num_signals', header.num_signals);    
end
%-------------------------------------------- Function PrintEdfSignalHeader
function PrintEdfSignalHeader(header, signalHeader)
    % Write signalHeader information to screen
    fprintf('\n\nSignal Header:');

    % Plot each signal
    for s = 1:header.num_signals
        % Write summary for each signal
        fprintf('\n\n%30s:  %s\n', ...
            'signal_labels', signalHeader(s).signal_labels);
        fprintf('%30s:  %s\n', ...
            'tranducer_type', signalHeader(s).tranducer_type);
        fprintf('%30s:  %s\n', ...
            'physical_dimension', signalHeader(s).physical_dimension);
        fprintf('%30s:  %.3f\n', ...
            'physical_min', signalHeader(s).physical_min);
        fprintf('%30s:  %.3f\n', ...
            'physical_max', signalHeader(s).physical_max);
        fprintf('%30s:  %.0f\n', ...
            'digital_min', signalHeader(s).digital_min);
        fprintf('%30s:  %.0f\n', ...
            'digital_max', signalHeader(s).digital_max);
        fprintf('%30s:  %s\n', ...
            'prefiltering', signalHeader(s).prefiltering);
        fprintf('%30s:  %.0f\n', ...
            'samples_in_record', signalHeader(s).samples_in_record);
        fprintf('%30s:  %s\n', 'reserve_2', signalHeader(s).reserve_2);
    end
end
%---------------------------------------------- Function PlotEdfSignalStart
function fig = PlotEdfSignalStart(header, signalHeader, signalCell, tmax)
    % Function for plotting start of edf signals

    % Create figure
    fig = figure();

    % Get number of signals
    num_signals = header.num_signals;

    % Add each signal to figure
    for s = 1:num_signals
        % get signal
        signal =  signalCell{s};
        samplingRate = signalHeader(s).samples_in_record;
        record_duration = header.data_record_duration;
        t = [0:length(signal)-1]/samplingRate';

        % Identify first 30 seconds
        indexes = find(t<=tmax);
        signal = signal(indexes);
        t = t(indexes);
        
        % Normalize signal
        sigMin = min(signal);
        sigMax = max(signal);
        signalRange = sigMax - sigMin;
        signal = (signal - sigMin);
        if signalRange~= 0
            signal = signal/(sigMax-sigMin); 
        end
        signal = signal -0.5*mean(signal) + num_signals - s + 1;         
        
        % Plot signal
        plot(t(indexes), signal(indexes));
        hold on
    end

    % Set title
    title(header.patient_id);
    
    % Set axis limits
    v = axis();
    v(1:2) = [0 tmax];
    v(3:4) = [-0.5 num_signals+1.5];
    axis(v);
    
    % Set x axis
    xlabel('Time(sec)');
    
    % Set yaxis labels
    signalLabels = cell(1,num_signals);
    for s = 1:num_signals
        signalLabels{num_signals-s+1} = signalHeader(s).signal_labels;
    end
    set(gca, 'YTick', [1:1:num_signals]);
    set(gca,'YTickLabel', signalLabels);

end








































