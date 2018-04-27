# WaVE

Wake Forest Visual Experimentation Software

This repository documents the Wake Forest Visual Experimentation Software as documented in:
Travis Meyer & Christos Constantinidis (2005)
Journal of Neuroscience Methods, 142 (1): 27-34
https://www.sciencedirect.com/science/article/pii/S0165027004002535



1. DESCRIPTION OF FILES 
-----------------------
i) CursorODR.m :
Stand-alone, demonstration script, implementing an 
oculomotor delayed response task, as well as a fixation 
and a visually-guided saccade task. Eye position is 
simulated by the mouse-controlled cursor.

ii) WaveGui.m, WaveGui.fig, WaveGuiLoad.m, 
WaveGuiLoad.fig, WaveGuiSave.m, WaveGuiSave.fig :
Files associated with the, optional, Graphical User 
Interface, which launches the CursorODR script and 
controls a number of behavioral parameters.

iii) ODR.m :
Script that controls the behavioral control during 
neurophysiological experimentation, provided for 
reference purposes. The script requires specific 
hardware and software to run (data acquisition board, 
analog eye position input, data acquisition Toolbox).


2. REQUIREMENTS
---------------
The CursorODR.m demonstration script was developed with
MATLAB 6.5 Release 13, and the Psychophysics Toolbox, 
version 2.50 available from: http://psychtoolbox.org/
Remember to include the Psychophysics toolbox directory 
in the MATLAB path and to place the CursorODR.m script 
in the working directory. 
The psychophysics toolbox developers recommend running 
MATLAB at the "nojvm" (no-Java virtual machine) mode, 
although we found no adverse consequence of running 
MATLAB in the multiple-window mode, for our 
application.


3. INSTRUCTIONS FOR STAND-ALONE PROGRAM
---------------------------------------
To run the stand-alone CursorODR program type 
"CursorODR" at the Matlab command window. The default 
mode of the program implements a fixation task. The 
fixation point appears first and the cursor must be 
placed on it, within 2 seconds. The cursor must stay at 
the fixation point while a cue stimulus appears in the 
periphery. Incorrect placement of the cursor at any 
stage results in the trial being aborted and a feedback 
tone being played. One block of eight trials, including 
8 cue locations around the center, will be delivered by 
default. To terminate the program early, press any 
mouse key.
IMPORTANT: the keyboard has been disabled; the program 
will not break with a control-break keystroke, only
with a mouse break. If for any reason the program 
crashes, the screen buffer must be cleared before it 
can run again: use the Screen('clearall') command. 
The program assumes a 1024-768 monitor resolution. 
Different screen resolutions will work, but the stimuli 
will not be centered on the screen (some may not be 
visible). The resolution, as well as the monitor size 
and viewing distance can be set appropriately by 
assigning an appropriate value to the corresponding
variable, in the first 3 lines of the script.


4. INSTRUCTIONS FOR GRAPHICAL USER INTERFACE
--------------------------------------------

To run the GUI-controlled task type "WaveGUI" at the 
Matlab command window. A Window appears, with the 
default values of the program. To launch the CursorODR 
program, after selecting the desired behavioral 
parameters click on the "Execute Trials" button.

i) The "Trial Type" pull-down menu allows the user to 
switch between 3 types of trials:
A Visual Guided Saccade task require sthe mouse 
cursor to be placed on the cue stimulus while 
it is still visible, but after the fixation point is 
turned off. A Delayed-response task, requires the 
cursor to be moved to the remembered location of the 
cue, after both the cue and the fixation point are 
turned off. A No-Saccade (Fixation) task is also 
implemented, as described in the previous section.

ii) The "Number of Blocks" window controls the number 
of groups of trials to be executed, in blocks of 8. 
The cue will appear randomly at one of eight symmetric 
locations around the fixation point in each block.

iii) The "Duration" fields allow the user to vary the 
duration of each the epochs in the task.

iv) The "Window Radii" fields control the eccentricity 
of the stimulus, and the size of the fixation and 
saccade windows within which the mouse must be placed. 
All measurements are in degrees, measured 60 cm away 
from a 33x27 cm monitor, by default. 

The desired behavioral parameters may be saved and 
later loaded from a file, using the "File" menu, at 
the menu bar.



