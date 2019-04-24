% heplab_fastdetect - ECGLAB fast peak detection, called by heplab.m
% 
% Modified version of the function developed by the group of
% Joao Luiz Azevedo de Carvalho at the University of Brasilia, DF, Brasil
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

function qrs = heplab_fastdetect(ecg,fs)

h = msgbox('R wave detection in progress... Please wait...');

ecg = double(ecg);
ecg = ecg(:);

% Filter at 17Hz
Q = 3;
gain = 1.2;
w0 = 17.5625*2*pi;
NUM = gain*w0^2;
DEN = [1,(w0/Q),w0^2];
[B,A] = bilinear(NUM,DEN,fs);

ecg_flt = filtfilt(B,A,ecg);

ecg_flt = filter([1 -1],1,ecg_flt);

% low-pass 30 Hz
[B,A] = butter(8,30/(fs/2));
ecg_flt = filter(B,A,ecg_flt);
ecg_flt = ecg_flt /max(abs(ecg_flt));

ecg_flt = ecg_flt.^2;

% integration
N = round(0.150*fs); ecg_flt=1/N*filter(ones(1,N),1,ecg_flt);

% start fast algorithm
% area to look for revents
area = round(0.070*fs);

% gain
gain = 0.15;

% comparison limit: 2 sec
comp = round(2*fs);

% minimum interval between marks (350ms)
step = round(0.350*fs);

% 10msec stet
step_10ms = round(0.01*fs);

ret = round(0.030*fs);

% initiate vars
sz = length(ecg);
n = 1;
Rwave = [];
qrs = [];

% repeat for every cardiac cycle
while n<sz,
    
    if (n+comp)<=sz,
        lmt = gain*max(abs(ecg_flt(n:n+comp)));
    else
        lmt = gain*max(abs(ecg_flt(sz-comp:sz)));
    end
    
    if ((ecg_flt(n)>lmt) && (n<sz)),
        Rwave=[Rwave;n];
        n=n+step;
    else
        n=n+step_10ms;
    end
end

% Locate R wave
% initiate vars
n = 1;
mark_count = length(Rwave);

%filter
[B,A] = butter(4,1/(fs/2),'high'); % cf = 1 Hz;
ecg_flt = filtfilt(B,A,ecg);

% return to signal
Rwave = Rwave-ret;
if Rwave(1)<1,Rwave(1)=1;end;

% locate R peaks
for i = 1:mark_count,
    
    if sz>=Rwave(i) + area,
        [~,mark] = max(abs(ecg_flt(Rwave(i):Rwave(i)+area)));
    else
        [~,mark] = max(abs(ecg_flt(Rwave(i):sz)));
    end
    
    % calculate and save mark
    mark = mark+Rwave(i)-1;
    qrs=[qrs;mark];    
end

if isempty(Rwave),
    qrs=-1;
end
close (h)