% heplab_ecgplot - Plots the ECG signal, called by heplab.m
%
% Modified version of ecglabRR included in ECGLAB
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

function handle=heplab_ecgplot(signal, srate, qrs, sec_ini, handle, winsec)

% delete previous plot
if handle~=-1,
    delete(handle);
end

% convert to single column
signal = signal(:);

% calculate sec_ini
sec_ini=sec_ini+1/srate;
win=floor(winsec*srate);

% zero after last sample
signal=[signal;0];

% segment signal to be plotted
ss = round(sec_ini*srate);
ecg = signal;
signal = signal(ss:ss+win);

% create time axis
t=sec_ini-1/srate:1/srate:sec_ini+winsec-1/srate;

% create handle
handle=axes('Units','normalized','FontUnits','normalized',...
    'position',[0.03916866506794564 0.2755905511811024 0.9200639488409272 0.6902887139107612]...
);

% plot ECG and IBIs
if isempty(qrs),
    plot(t,signal,'b-');
    r_ind=[];
else
    r_ind=qrs; qrs=-1500*ones(length(ecg),1);
    qrs(r_ind)=ecg(r_ind);
    qrs=qrs(ss:ss+win);
    
    plot(t,signal,'b-',t,qrs,'ro');
end

% find events within window
[RRinterval, RRtimes]=heplab_calculate_IBIs(r_ind,length(ecg)*1/srate,srate);
if RRinterval(1)~=-1,
    
    display=find(RRtimes>=t(1) & RRtimes<=t(length(t)));
    r_ind_aux=r_ind(display);
    RRtimes=RRtimes(display);
    RRinterval=RRinterval(display);
    
    % show event indexes when win < 10sec
    if winsec <=10,
        for i=1:length(RRinterval),
            xRR=RRtimes(i);
            yRR=ecg(r_ind(display(1)+i));
            RRtext=sprintf([  num2str(RRinterval(i))  '[' num2str(display(1)+i-1) ']-'  ]);
            h=text(xRR,yRR,RRtext);
            set(h,'fontname','Courier New','fontsize',12,'HorizontalAlignment','right','verticalalignment','middle')
        end
    end
end

grid
axis([t(1) t(length(t)) -0.1 1.1])
xlabel('Time (sec)','fontsize',12)
ylabel('Normalized amplitude','fontsize',12)