% heplab_slowdetect - ECGLAB slow peak detection, called by heplab.m
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

function qrs = heplab_slowdetect(ecg,fs)

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

% start slow algorith
% find peak
step = 0.200*fs;
area = 2*fs;
ret = 0.160*fs;

sz = length(ecg);
ecg_temp = -1500*ones(sz,1);
n = 1;
qrs = [];

% repeat for every cardiac cycle
while n<sz,
    maxval = 0;
    ind = 0;
    
    if (n+area)<=sz,
        lm = 0.15*max(abs(ecg_flt(n:n+area)));
    else
        lm = 0.15*max(abs(ecg_flt(sz-area:sz)));
    end
    

    while ( (ecg_flt(n)>lm) && (n<sz) ),       
        if abs(ecg_flt(n))>maxval,
            maxval = abs(ecg_flt(n));
            ind = n;
        end
        n = n+1;
        
    end
    
    if ind~=0,
        ecg_temp(ind) = 1;
        n = ind+step;
        
    else
        n = n+1;
    end
    
end

for kk=1:fs:sz-fs,
    ecg(kk:kk+fs-1) =...
        ecg(kk:kk+fs-1) - mean(ecg(kk:kk+fs-1));
end

dl = ret;
n = 1;

while n<=sz,
    maxval = 0;
    ind = 0;
    
    while ( (ecg_temp(n)==1) && (n<=sz) ),
        
        if (n-dl)>0,
            ini = n-ret;
        else
            ini = 1;
        end
        
        [maxval,ind] = max(abs(ecg(ini:n)));
        ind = fix(ini+ind-1);
        qrs = [qrs;ind];
        n = n+1;
    end
    n = n+1;
end

if isempty(qrs),
    qrs=-1;
end

close (h)