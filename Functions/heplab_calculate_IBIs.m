% heplab_calculate_IBIs - Calculates IBIs, called by heplab_ecgplot.m
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


function [RRinterval, RRtimes]=heplab_calculate_IBIs(qrs,signal_sec,srate)

if length(qrs)>1,
    
    time=0:1/srate:signal_sec-1/srate; % time axis
    
    % convert to ms
    RRtimes=round(1000*time(qrs));
    
    % calculate IBIs
    RR=RRtimes(1:length(RRtimes)-1);
    RR1=RRtimes(2:length(RRtimes));
    RRinterval=RR1-RR;
    
    % convert to sec and remove first interval
    RRtimes=RRtimes(2:length(RRtimes))/1000;
    
    % round IBIs
    RRinterval=round(RRinterval);
    
else
    RRinterval=-1;
    RRtimes=-1;
end

