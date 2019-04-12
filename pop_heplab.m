%function HEP = pop_heplab (EEG)

% hepgui.header=sprintf([...
%       'ECGLAB - qrs Detection Module\n\n\n',...
%       'Jo?o Luiz Azevedo de Carvalho, Ph.D.\n\n\n',...
%       'Digital Signal Processing Group\n',...
%       'Department of Electrical Engineering\n',...
%       'School of Technology\n',...
%       'University of Brasilia\n\n\n',...
%       'joaoluiz@gmail.com',...
% ]);

clear HEP

tmpchanlocs = EEG(1).chanlocs;
[ecg_chn] = heplab_chansel({tmpchanlocs.labels},'selectionmode','single',...
    'withindex', 'on');

if ~isempty(ecg_chn)
    ecg = double(EEG.data(ecg_chn,:));
    ecg = ecg(:); % make sure ecg is one-column vector
    
    HEP.ecg = ecg/max(abs(ecg)); % normalise ecg
    HEP.ecg_handle = -1;
    HEP.srate = EEG.srate;
    HEP.winsec = 10; %janela de tempo mostrada no grafico
    HEP.sec_ini = 0; %posicao inicial do grafico
    HEP.qrs = [];
    HEP.ecg_dur_sec=length(HEP.ecg)/HEP.srate;
    
    if HEP.ecg_dur_sec-HEP.winsec > 0
        HEP.slider_max = HEP.ecg_dur_sec-HEP.winsec;
    else
        HEP.winsec = HEP.ecg_dur_sec;
        HEP.slider_max = 0;
    end
    
    clear ecg ecg_chn tmpchanlocs
    heplab_main
end


