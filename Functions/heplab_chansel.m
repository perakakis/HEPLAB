% heplab_chansel - GUI to select ECG channel, called by pop_heplab.m
%
% Modified version of pop_chansel() function included in EEGLAB
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

function [chanlist,chanliststr, allchanstr] = heplab_chansel(chans, varargin)
    
    if nargin < 1
        help pop_chansel;
        return;
    end;
    if isempty(chans), disp('Empty input'); return; end;
    if isnumeric(chans),
        for c = 1:length(chans)
            newchans{c} = num2str(chans(c));
        end;
        chans = newchans;
    end;
    chanlist    = [];
    chanliststr = {};
    allchanstr  = '';
    
    g = finputcheck(varargin, { 'withindex'     {  'integer';'string' } { [] {'on' 'off'} }   'off';
                                'select'        { 'cell';'string';'integer' } [] [];
                                'selectionmode' 'string' { 'single';'multiple' } 'multiple'});
    if isstr(g), error(g); end;
    if ~isstr(g.withindex), chan_indices = g.withindex; g.withindex = 'on';
    else                    chan_indices = 1:length(chans);
    end;
    
    % convert selection to integer
    % ----------------------------
    if isstr(g.select) & ~isempty(g.select)
        g.select = parsetxt(g.select);
    end;
    if iscell(g.select) & ~isempty(g.select)
        if isstr(g.select{1})
            tmplower = lower( chans );
            for index = 1:length(g.select)
                matchind = strmatch(lower(g.select{index}), tmplower, 'exact');
                if ~isempty(matchind), g.select{index} = matchind;
                else error( [ 'Cannot find ''' g.select{index} '''' ] );
                end;
            end;
        end;
        g.select = [ g.select{:} ];
    end;
    if ~isnumeric( g.select ), g.select = []; end;
    
    % add index to channel name
    % -------------------------
	tmpstr = {chans};
    if isnumeric(chans{1})
        tmpstr = [ chans{:} ];
        tmpfieldnames = cell(1, length(tmpstr));
        for index=1:length(tmpstr), 
            if strcmpi(g.withindex, 'on')
                tmpfieldnames{index} = [ num2str(chan_indices(index)) '  -  ' num2str(tmpstr(index)) ]; 
            else
                tmpfieldnames{index} = num2str(tmpstr(index)); 
            end;
        end;
    else
        tmpfieldnames = chans;
        if strcmpi(g.withindex, 'on')
            for index=1:length(tmpfieldnames), 
                tmpfieldnames{index} = [ num2str(chan_indices(index)) '  -  ' tmpfieldnames{index} ]; 
            end;
        end;
    end;
    [chanlist,tmp,chanliststr] = listdlg2('PromptString',strvcat('Select ECG channel'), ...
                'ListString', tmpfieldnames, 'initialvalue', g.select, 'selectionmode', g.selectionmode);   
    if tmp == 0
        chanlist = [];
        chanliststr = '';
        return;
    else
        allchanstr = chans(chanlist);
    end;
    
    % test for spaces
    % ---------------
    spacepresent = 0;
    if ~isnumeric(chans{1})
        tmpstrs = [ allchanstr{:} ];
        if ~isempty( find(tmpstrs == ' ')) | ~isempty( find(tmpstrs == 9))
            spacepresent = 1;
        end;
    end;
    
    % get concatenated string (if index)
    % -----------------------
    if strcmpi(g.withindex, 'on') | spacepresent
        if isnumeric(chans{1})
            chanliststr = num2str(celltomat(allchanstr));
        else
            chanliststr = '';
            for index = 1:length(allchanstr)
                if spacepresent
                    chanliststr = [ chanliststr '''' allchanstr{index} ''' ' ];
                else
                    chanliststr = [ chanliststr allchanstr{index} ' ' ];
                end;
            end;
            chanliststr = chanliststr(1:end-1);
        end;
    end;
       
    return;
