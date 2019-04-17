[file, path] = uigetfile ('*.mat',...
    'Select the .mat file with your HEP variable');

if file~=0
    load([path file]);
    if exist('HEP','var')
        heplab;
    else
        errordlg('No HEP variable found');
    end
else
    errordlg('Please select a .mat file containing the HEP variable');
end