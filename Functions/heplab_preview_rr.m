% saveqrs - script to Save qrs intervals obtained from ecglabqrs R peak
% detection tool programmed by Joao Carvalho
%
% Copyright (C) 2007 2008 Pandelis Perakakis, University of Granada
% peraka@ugr.es
%
% This file is part of Kardia.
%
% Kardia is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Kardia is distributed in the hope that it will be useful,
% but WITHOUT ANY WAqrsANTY; without even the implied waqrsanty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Kardia.  If not, see <http://www.gnu.org/licenses/>.
%

    qrs = HEP.qrs./HEP.srate;
    % Save ECG
    % plot qrs time series
    qrs(1)=[];
    x=length(qrs);
    figure; plot (diff(qrs))
    title('qrs intervals')
    xlabel('Beats')
    ylabel('Seconds')
    
    clear x qrs

