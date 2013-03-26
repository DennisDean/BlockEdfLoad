BlockEdfLoad
============

A fast EDF loader

Brief Tutorial
The following tutorial demonstrates the commands required to load an EDF into MATLAB and to access a specific signal present in the EDF file. Additional examples for accessing the information available in an EDF can be found in the test file that is bundled with the loader script file. It is assumed that the reader is familiar with MATLAB. Readers unfamiliar with MATLAB are encouraged to complete a MATLAB tutorial.

(1) Download loader and test file
Download the loader and test file from https://github.com/DennisDean/. Unzip the download into a folder. Open MATLAB and change the directory to the folder with the loader and test file.

(2) Prepare to load a file
Prepare to load the EDF by clearing the console, clearing the workspace, and closing all figures.  Define the file to read. Type the following commands.
         
         >> clc; clear; close all
         
         >> edfFn1 = 'test_generator.edf';
         
         >> [header signalHeader signalCell] = blockEdfLoad(edfFn1);
         
         >> header

(3) Inspect the loaded variables
Type the following commands to inspect the variables created by the load command.
         
         >> header
        
         >> signalHeader
        
         >> signalCell
Typing each of the variables results in the variable contents to be displayed on the screen as shown below.
         
          >> header = 
                          edf_ver: '0'
                       patient_id: 'test file'
                     local_rec_id: 'EDF generator'
              recording_startdate: '02.10.08'
              recording_starttime: '14.27.00'
                 num_header_bytes: 4352
                        reserve_1: ''
                 num_data_records: 900
             data_record_duration: 1
                      num_signals: 16
        
        >> signalHeader
         signalHeader = 
         1x16 struct array with fields:
             signal_labels
             tranducer_type
             physical_dimension
             physical_min
             physical_max
             digital_min
             digital_max
             prefiltering
             samples_in_record
             reserve_2
         >> signalCell
                  signalCell = 
                    Columns 1 through 5
             [180000x1 double]    [90000x1 double]    [180000x1 double]    [180000x1 double]    [45000x1 double]
                    Columns 6 through 10
                      [90000x1 double]    [180000x1 double]    [180000x1 double]    [180000x1 double]    [180000x1 double]
                    Columns 11 through 15
                      [180000x1 double]    [180000x1 double]    [180000x1 double]    [22500x1 double]    [22500x1 double]
                    Column 16
                      [22500x1 double]

(4) Create variables for plotting
Type the following command to create plotting variables.
         >> signal = signalCell{1};
         
         >> samplingRate = signalHeader(1).samples_in_record;
         
         >> t = [0:length(signal)-1]/samplingRate';
         
         >> numSamplesIn30Seconds = 30*samplingRate;

(5) Plot data
Type the following command to plot the first 30 seconds of the first signal.
         
         >> plot(t(1:numSamplesIn30Seconds), signal(1:numSamplesIn30Seconds));
         
         >> title('Test Signal')
         
         >> xlabel('Time (sec.)')
         
         >> ylabel('Signal Amplitude')

