function qrs=heplab_edit_qrs(ecg,srate,qrs,ecg_handle,sec_ini,winsec,ecg_dur_sec)
% usage:

sec_fin=sec_ini+winsec;
time=(0:1/srate:ecg_dur_sec-1/srate)';

%precisao do mouse em pixels (para tras e para frente): 1->otima, 20->usuario vesgo
click_precision=10;

%raio da clicada
x_range=0.01*(sec_fin-sec_ini);
y_range=0.04*2;
s_range=round(x_range*srate);

%le qual o point clicado no grafico do ecg
point=get(ecg_handle,'CurrentPoint');

x=point(1,1);
y=point(2,2);

%verifica se clicou dentro do ecg
if abs(y)<=1 & x>=sec_ini & x<sec_fin,
    
    ind=find(ecg>=y-y_range & ecg<=y+y_range & time>=x-x_range & time<=x+x_range);
    
    if isempty(ind)~=1,
        
        emq=((x-time(ind))/(sec_fin-sec_ini)).^2+((y-ecg(ind))/2).^2;
        ind=ind(find(emq==min(emq)));
        
        
        %verifica se ha uma qrs_old nessa regiao
        qrs_old=find(qrs>=ind-s_range & qrs<=ind+s_range);
        
        %se nao houver, faz a qrs_old
        if isempty(qrs_old),
            qrs=sort([qrs;ind]);
            
            %se houver, apaga a qrs_old
        else
            del_qrs=qrs(qrs_old(1));
            keep_qrs=find(qrs~=del_qrs);
            if isempty(keep_qrs)~=1,
                qrs=qrs(keep_qrs);
            else
                qrs=[];
            end
        end
    end
end