function ecgout=heplab_ecg_filt(ecgin, fecg, fc_inf, fc_sup)
% Butterworth filter for ECG
% Inputs:
%    ecgin - ECG signal to be filtered
%    fecg - sampling frequency (Hz)
%
% Output:
%    ecgout - filtered ECG signal
%

% Cutoff frequency
% fc_inf=.5;
% fc_sup=50;

% Filter order
ord=2;

% Filter
Wn = [fc_inf fc_sup]/fix(fecg/2); 
[B,A] = butter (ord,Wn);
ecgout = filtfilt (B,A,ecgin);
