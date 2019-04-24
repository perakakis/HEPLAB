% heplab_ecg_filt - Applies a Butterworth filter, called by heplab.m
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

function ecgout=heplab_ecg_filt(ecgin, fecg, fc_inf, fc_sup)

% Filter order
ord=2;
ecgin = double(ecgin);

% Filter
Wn = [fc_inf fc_sup]/fix(fecg/2);
[B,A] = butter (ord,Wn);
ecgout = filtfilt (B,A,ecgin);
ecgout = (ecgout-min(ecgout))/(max(ecgout)-min(ecgout));

