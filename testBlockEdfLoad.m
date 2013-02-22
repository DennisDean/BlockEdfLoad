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
%    Test 2: Load and plot data from a sleep study
%    Test 3: Compare traditional and block load with generated file
%    Test 4: Compare traditional and block load with SHHS file
%    Test 5: Compare multiple traditional and block loads with SHHS file
%    Test 6: load and plot a collaborators file that has a 6 second record
%    Test 7: load and plot DSM file that has a 6 second record
%    Test 8: Incrementally load header, signalHeader and signalCell
%    Test 9: Return information for selected signals
%
% External Reference:
%   edfRead.m
%   www.mathworks.com/matlabcentral/fileexchange/31900-edfread
%
%   test_generator.edf (EDF Browswer Website)
%   http://www.teuniz.net/edf_bdf_testfiles/index.html
%
%   201434.EDF
%   https://sleepepi.partners.org/hybrid/
%
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
% Last update:  January 6, 2013 
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
edfFn1 = 'test_generator.edf';    % Generated data file
edfFn2 = '201434.EDF';            % Sleep 
edfFn3 = 'AD201A.EDF';            % Collaborator File
edfFn4 = '1020 sample EDF.edf';   % Division of Sleep Medicine File

% Test flags
RUN_TEST_1 = 0;  % Generated File: Open and plot first 30 seconds
RUN_TEST_2 = 1;  % SHHS File: Open and plot first 30 seconds
RUN_TEST_3 = 0;  % Generated File: Traditional vs. Block Load
RUN_TEST_4 = 0;  % SHHS File: Traditional vs. Block Load
RUN_TEST_5 = 0;  % SHHS File: Multiple Traditional vs. Block Loads
RUN_TEST_6 = 0;  % Collaborator file: 6 second record size
RUN_TEST_7 = 0;  % DSM file
RUN_TEST_8 = 0;  % Incrementally load header, signalHeader and signalCell
RUN_TEST_9 = 0;  % Incrementally load header, signalHeader and signalCell


% Test parameters
NUMBER_OF_LOADS = 10;

% ------------------------------------------------------------------ Test 1
% Test 1: Load and plot generated file
if RUN_TEST_1 == 1
    % Open generated test file
    [header signalHeader signalCell] = blockEdfLoad(edfFn1);

    % Write test results to console
    fprintf('------------------------------- Test 1\n\n');
    fprintf('Load and plot generated file\n\n');
    % Show file contents
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    tmax = 30;

    % Plot First 30 Seconds
    fprintf('\nPlotting first 30 seconds\n\n');
    fig1_2 = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
end


% ------------------------------------------------------------------ Test 2
% Test 2: Load and plot data from a sleep study
if RUN_TEST_2 == 1
    % Open Sleep Heart Health Sutdy edf
    [header signalHeader signalCell] = blockEdfLoad(edfFn2);

    % Write test results to console
    fprintf('------------------------------- Test 2\n\n');
    fprintf('Load and plot generated file\n\n');
    
    % Show file contents
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    tmax = 30;

    % Plot first 30 seconds
    fprintf('\nPlotting first 30 seconds\n\n');
    fig2_2 = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);
end

% ------------------------------------------------------------------ Test 3
% Test 3: Compare traditional and block load with generated file
if RUN_TEST_3 == 1
    % Traditional Load
    fprintf('------------------------------- Test 3\n\n');
    fprintf('File Load Test: %s\n', edfFn1);

    % Traditional Load
    tic
    [hdr, record] = edfRead(edfFn1);
    elapsed_time_1 = toc;

    % Block EDF Load
    tic
    [header signalHeader signalCell] = blockEdfLoad(edfFn1);
    elapsed_time_2 = toc;

    % Write load times to console
    fprintf('Traditional Load = %0.2f sec., Block Load = %0.2f sec., Load time ratio = %0.2f%%\n\n',...
        elapsed_time_1, elapsed_time_2, elapsed_time_2/elapsed_time_1*100)
end

% ------------------------------------------------------------------ Test 4
% Test 4: Compare traditional and block load with SHHS file
if RUN_TEST_4 == 1
    % Traditional Load
    fprintf('------------------------------- Test 4\n\n');
    fprintf('File Load Test: %s\n', edfFn2);

    % Traditional Load
    tic
    [hdr, record] = edfRead(edfFn2);
    elapsed_time_1 = toc;

    % Block EDF Load
    tic
    [header signalHeader signalCell] = blockEdfLoad(edfFn2);
    elapsed_time_2 = toc;

    % Write load times to console
    fprintf('Traditional Load = %0.2f sec., Block Load = %0.2f sec., Load time ratio = %0.2f%%\n\n',...
        elapsed_time_1, elapsed_time_2, elapsed_time_2/elapsed_time_1*100)
end

% ------------------------------------------------------------------ Test 5
% Test 5: Compare multiple traditional and block loads with SHHS file
if RUN_TEST_5 == 1
    % Traditional Load
    fprintf('------------------------------- Test 5\n\n');
    fprintf('Multiple File Load Test: %s\n', edfFn2);

    % Traditional Load
    for r = 1:NUMBER_OF_LOADS
        tic
        [hdr, record] = edfRead(edfFn2);
        elapsed_time_1(r) = toc;
    end

    % Block EDF Load
    for r = 1:NUMBER_OF_LOADS
        tic
        [header signalHeader signalCell] = blockEdfLoad(edfFn2);
        elapsed_time_2(r) = toc;
    end

    % Write load times to console
    t1avg = mean(elapsed_time_1);
    t2avg = mean(elapsed_time_2);
    t1std = std(elapsed_time_1);
    t2std = std(elapsed_time_2);
    t2_t1_ratio = t2avg/t1avg;
    fprintf('Traditional Load = %0.2f (%0.2f) sec., Block Load = %0.2f (%0.2f) sec., Load time ratio = %0.2f%%\n\n',...
        t1avg, t1std, t2avg, t2std, t2_t1_ratio);
end

%------------------------------------------------------------------- Test 6
% Test 6: load and plot a collaborators file that has a 6 second record
if RUN_TEST_6 == 1
    % Test Collaborator's EDF file that doesn't has a record size > 1 sec
    % Open generated test file
    [header signalHeader signalCell] = blockEdfLoad(edfFn3);

    % Write test results to console
    fprintf('------------------------------- Test 1\n\n');
    fprintf('Load and plot a collaborators file that has a 6 second record\n\n');
    
    % Show file contents
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    tmax = 30;

    % Plot First 30 Seconds
    fprintf('\nPlotting first 30 seconds\n\n');
    fig1_2 = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);        
end
%------------------------------------------------------------------- Test 7
% Test 7: load and plot of DSM generated EDF
if RUN_TEST_7 == 1
    % Test Collaborator's EDF file that doesn't has a record size > 1 sec
    % Open generated test file
    tic
    [header signalHeader signalCell] = blockEdfLoad(edfFn4);
    toc

    % Write test results to console
    fprintf('------------------------------- Test 7\n\n');
    fprintf('Load and plot DSM file\n\n');
    
    % Show file contents
    PrintEdfHeader(header);
    PrintEdfSignalHeader(header, signalHeader);
    tmax = 30;

    % Plot First 30 Seconds
    fprintf('\nPlotting first 30 seconds\n\n');
    fig1_2 = PlotEdfSignalStart(header, signalHeader, signalCell, tmax);        
end
%------------------------------------------------------------------- Test 8
% Test 8: Incrementally load EDF components
if RUN_TEST_8 == 1
    % Load header, signalHeader and signalCell incrementally
    tic
    header = blockEdfLoad(edfFn3);
    tHeader = toc;
    
    tic
    [header signalHeader] = blockEdfLoad(edfFn3);
    tSignalHeader = toc;

    tic
    [header signalHeader signalCell] = blockEdfLoad(edfFn3);
    tSignalCell = toc;
    

    % Write test results to console
    fprintf('------------------------------- Test 8\n\n');
    fprintf('Incrementally load EDF components\n\n');
    

    % Plot First 30 Seconds
    fprintf('\n(header, signalHeader, signalCell) = ');
    fprintf('(%0.3f, %0.3f, %0.3f)\n\n', tHeader, tSignalHeader, tSignalCell); 
end
%------------------------------------------------------------------- Test 9
% Test 9: Return selected signals
if RUN_TEST_9 == 1
    
    % Selected Signals
    signalLabels = {'Pleth', 'EKG-R-EKG-L', 'Abdominal Resp'}; 

    % Write test results to console
    fprintf('------------------------------- Test 9\n\n');
    fprintf('Load reduced data set \n\n');
    
    % Load header, signalHeader and signalCell incrementally
    [header signalHeader signalCell] = blockEdfLoad(edfFn3, signalLabels);
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








































