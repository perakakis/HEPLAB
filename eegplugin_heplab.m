% eegplugin_heplab - Loads HEPLAB as an EEGLAB plugin
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

function eegplugin_heplab(fig, trystrs, catchstrs)
    
    if nargin < 3
        error('eegplugin_heplab requires 3 arguments');
    end;
    
    p = which('eegplugin_heplab','-all');
    p = p{1};
    p = p(1:findstr(p,'eegplugin_heplab.m')-1);
    addpath(genpath(p))
    
    % find tools menu
    % ---------------
    toolsmenu = findobj(fig, 'tag', 'tools');
      
    % create menus
    % ------------
    hepmenu = uimenu( toolsmenu,'Label','HEPLAB','separator','on',...
        'tag','heplab','userdata',...
        'startup:off;continuous:on;epoch:off;study:off;erpset:off',...
        'Callback','pop_heplab');
    