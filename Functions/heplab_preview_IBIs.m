% heplab_preview_IBIs - Plot IBIs, called by heplab.m
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

qrs = HEP.qrs./HEP.srate;
qrs(1)=[];

% plot in a new figure
figure; plot (diff(qrs))
title('Interbeat Intervals')
xlabel('Beats')
ylabel('Seconds')

clear x qrs

