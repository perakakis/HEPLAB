% heplab_save_events - Add events to EEG structure, called by heplab.m
%
% Copyright (C) 2019 Pandelis Perakakis, Granada University, peraka@ugr.es
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

k = length(EEG.event); % number of existing events in the EEG structure
urevents = num2cell(k+1:k+length(HEP.qrs));
evt = num2cell(HEP.qrs);
types = repmat({'ECG'},1, length(evt));

[EEG.event(1,k+1:k+length(HEP.qrs)).latency] = evt{:}; % assign latencies
[EEG.event(1,k+1:k+length(HEP.qrs)).type] = types{:}; % assign types
[EEG.event(1,k+1:k+length(HEP.qrs)).urevent] = urevents{:}; % assign event index

% save new set
[ALLEEG,EEG,CURRENTSET] = pop_newset(ALLEEG,EEG,CURRENTSET);
clear k evt urevents types
close (hepgui.main) % close the HEPLAB GUI
eeglab redraw