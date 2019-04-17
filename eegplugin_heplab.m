% eegplugin_dipfit() - DIPFIT plugin version 2.0 for EEGLAB menu. 
%                      DIPFIT is the dipole fitting Matlab Toolbox of 
%                      Robert Oostenveld (in collaboration with A. Delorme).
%
% Usage:
%   >> eegplugin_dipfit(fig, trystrs, catchstrs);
%
% Inputs:
%   fig        - [integer] eeglab figure.
%   trystrs    - [struct] "try" strings for menu callbacks.
%   catchstrs  - [struct] "catch" strings for menu callbacks.
%
% Notes:
%   To create a new plugin, simply create a file beginning with "eegplugin_"
%   and place it in your eeglab folder. It will then be automatically 
%   detected by eeglab. See also this source code internal comments.
%   For eeglab to return errors and add the function's results to 
%   the eeglab history, menu callback must be nested into "try" and 
%   a "catch" strings. For more information on how to create eeglab 
%   plugins, see http://www.sccn.ucsd.edu/eeglab/contrib.html
%
% Author: Arnaud Delorme, CNL / Salk Institute, 22 February 2003
%
% See also: eeglab()

% Copyright (C) 2003 Arnaud Delorme, Salk Institute, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1.07  USA

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
    