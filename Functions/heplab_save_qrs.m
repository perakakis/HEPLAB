% mergeRR
% -----------------
% Curso HEP Granada 2018
% Pandelis Perakakis, Luis Ciria
% peraka@ugr.es, lciria@ugr.es
% ------------------------------
%
% create new events for R peaks in the eeg continuous signal
%
% load the eeglab .set file with the continuous EEG signal called
% ENT_1_processed.set using the eeglab GUI or the script below

%
% look for cue and target events in Block 1

k = length(EEG.event); % number of existing events in the EEG structure
urevents = num2cell(k+1:k+length(HEP.qrs));
evt = num2cell(HEP.qrs);
types = repmat({'QRS'},1, length(evt));

[EEG.event(1,k+1:k+length(HEP.qrs)).latency] = evt{:}; % assign latencies
[EEG.event(1,k+1:k+length(HEP.qrs)).type] = types{:}; % assign types
[EEG.event(1,k+1:k+length(HEP.qrs)).urevent] = urevents{:}; % assign event index

%
% % save new set
% EEG = pop_saveset(EEG, 'filename','ENT_1_Revents.set'); % save EEG set
% save ('ENT_1_RT.mat', 'RTs'); % save reaction times
%pop_saveset(EEG);
[ALLEEG,EEG,CURRENTSET] = pop_newset(ALLEEG,EEG,CURRENTSET);
clear k evt urevents types
close (hepgui.main)
eeglab redraw