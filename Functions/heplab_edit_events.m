% heplab_edit_events - Manualy edit cardiac events, called by heplab.m
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

function events=heplab_edit_events(ecg,srate,events,ecg_handle,sec_ini,winsec,ecg_dur_sec)

ecg = ecg(:);

sec_fin=sec_ini+winsec;
time=(0:1/srate:ecg_dur_sec-1/srate)';

x_range=0.01*(sec_fin-sec_ini);
y_range=0.04*2;
s_range=round(x_range*srate);

point=get(ecg_handle,'CurrentPoint');

x=point(1,1);
y=point(2,2);

if abs(y)<=1 && x>=sec_ini && x<sec_fin,
    
    ind=find(ecg>=y-y_range & ecg<=y+y_range & time>=x-x_range & time<=x+x_range);
    
    if isempty(ind)~=1,
        
        emq=((x-time(ind))/(sec_fin-sec_ini)).^2+((y-ecg(ind))/2).^2;
        ind=ind(find(emq==min(emq)));
        
        events_old=find(events>=ind-s_range & events<=ind+s_range);
        
        if isempty(events_old),
            events=sort([events;ind]);
            
        else
            del_events=events(events_old(1));
            keep_events=find(events~=del_events);
            if isempty(keep_events)~=1,
                events=events(keep_events);
            else
                events=[];
            end
        end
    end
end