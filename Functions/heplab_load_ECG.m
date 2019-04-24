% heplab_load_ECG - Load ECG from .mat file, called by heplab.m
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


[file, path] = uigetfile ('*.mat',...
    'Select the .mat file with your ''ecg'' and ''srate'' variables');

if file~=0
    load([path file]);
    if exist('ecg','var') && exist('srate','var')
        clear HEP
        ecg = double(ecg);
        ecg = ecg(:); % make sure ecg is one-column vector
        HEP.ecg = (ecg-min(ecg))/(max(ecg)-min(ecg));
        HEP.srate = srate;
        HEP.winsec = 10; %janela de tempo mostrada no grafico
        HEP.sec_ini = 0; %posicao inicial do grafico
        HEP.qrs = [];
        clear ecg srate file path
        heplab;
    else
        errordlg('No ''ecg'' or ''srate'' variable found');
    end
else
    errordlg('Please select a file containing the ''ecg'' and ''srate'' variables');
end