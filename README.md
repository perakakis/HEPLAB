# HEPLAB

HEPLAB is an [EEGLAB](https://sccn.ucsd.edu/eeglab/index.php) plugin for the automatic detection of cardiac-related events from the raw ECG signal. Users can choose among three different algorithms for **R wave** detection and one algorithm for **T wave** detection. An intuitive Graphical User Interface (GUI) displays cardiac events on top of the ECG signal and allows users to manually correct for artifacts. Events can then be exported to EEGLAB's EEG structure to facilitate the analysis of the Heartbeat Evoked Potential (HEP).

# Detection algorithms
HEPLAB implements the following peak detection algorithms

## Pan and Tompkins [Pan & Tompkins, 1985](Documentation/Articles/PanTompkins.pdf)
The implementation of this algorithm is a modified version of the routine ```BioSigKit.PanTompkins()```) that is distributed with the [BioSigKit toolbox](http://joss.theoj.org/papers/10.21105/joss.00671), developed by 
[Hooman Sedghamiz](https://github.com/hooman650).

## ECGLAB fast and slow algorithms [Carvalho et al., 2002]Documentation/Articles/icsp2002_ecglab.pdf)
These two algorithms are modified versions of the routines included in the ECGLAB toolbox, developed by the group of João Luiz Azevedo de Carvalho at the University of Brasilia, DF, Brasil.

## QRS Multilevel Teager Energy Operator (MTEO) [Sedghamiz & Santonocito](http://ieeexplore.ieee.org/document/7391510/)
This algorithm is again a modified version of the routine ```BioSigKit.MTEO_qrstAlg()``` distributed with the [BioSigKit toolbox](http://joss.theoj.org/papers/10.21105/joss.00671), developed by [Hooman Sedghamiz](https://github.com/hooman650).

# Installation
To install HEPLAB download the [latest release from the Github repository](https://github.com/perakakis/HEPLAB) and include the unzipped folder in the ```plugins```folder of your EEGLAB distribution. Next time you run EEGLAB by typing ```eeglab``` at the command window, HEPLAB folders will be automatically included in your Matlab path.

# GUI
To open HEPLAB's GUI first you need to import your **continuous** data into EEGLAB using one of the available options depending on your data format. At the moment, HEPLAB only works with continous data so make sure you take this into account in your analysis workflow and perform cardiac event detection *before* segmenting your data into epochs.

Once your data is loaded, select the ```Tools``` tab at EEGLAB's main window. You will see ```HEPLAB``` as one of the available tools. Clicking on ```HEPLAB``` first lets you select your ECG channel and then opens the main GUI with all available functions and options.




