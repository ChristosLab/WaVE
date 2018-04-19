function CursorODR(varargin)
%  CursorODR displays visual stimuli on the primary monitor while 
%  mouse coordinates are sampled. Three trial types are possible:
%  "Visually guided saccade" requires the mouse to be moved to the fixation
%  point and after a stimulus appears and the fixation point turns off, to
%  be moved to the location of the stimulus.
%  "Memory guided saccade" requires the subject to remember the cued location, 
%  then when fixation point is off, to move mouse cursor to this location.
%  "No saccade" requires the mouse to only fixate throughout the trial
%  Travis Meyer 05-3-04  Version 1.0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vstruct.res = [1024 768];     % screen resolution
vstruct.siz = [33 27];        % screen size in cm
vstruct.dis = 60;             % viewing distance in cm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1                      %  If there are no arguments given
    datain(1:4) = [2 .5 .5 .5];       %  Default waiting times for each frame
    datain(5) = 3;                 %  Trial type
    datain(6) = 1;                 %  Number of trials
    datain(7) = 10;                %  Stimulus eccentricity
    datain(8) = 1;                %  Radius in degrees of fixation window
    datain(9) = 1;                %  Radius in degrees of target window
else
    % arguments exist from Gui, use them
    dataintemp = varargin(1);      % varargin is cell and convert to structure
    datain(1:9) = dataintemp{1,1};
    datasin = varargin(2);
end

%  Calculate Pixels/Degree using CalcAngs function
pix=vstruct.siz./vstruct.res; %calculates the size of a pixel in cm
degpix=(2*atan(pix./(2*vstruct.dis))).*(180/pi);
pixdeg=1./degpix;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Calculate the coordinates using the pixels/degree var
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vstruct.ang = datain(7);                 % excentricity, will be inputed by user
angs = [360 45 90 135 180 225 270 315];  % angles
radians = (angs*0.0174532925)';          % convert degrees to radians
coors(:,1) = cos(radians)*vstruct.ang;   % Calculate all x coordinates
coors(:,2) = sin(radians)*vstruct.ang;   % Calculate all y coordinates
pixs(:,1) = pixdeg(1,1)*coors(:,1);      % Convert x degs to pixels
pixs(:,2) = pixdeg(1,2)*coors(:,2);      % Convert y degs to pixels
pixs(1:1:8,:) = pixs(8:-1:1,:);          % Invert the pixels to clockwise order

StimSize = [5 5];                        % size of the stimuli in pixels
FixCoors = datain(8)*pixdeg;             % Radius of window in degrees
FixationWindow = (FixCoors(1)^2)+(FixCoors(2)^2);
TarCoors   = datain(9)*pixdeg;           % Radius of window in degrees
TargetWindow = (TarCoors(1)^2)+(TarCoors(2)^2);

centerX = vstruct.res(1,1)/2;            % Calculate the center of the screen (X)
centerY = vstruct.res(1,2)/2;            % Calculate the center of the screen (Y)
X1 = centerX-StimSize(1,1);              % With center pixel, make rectangle around it
X2 = centerX+StimSize(1,1);
Y1 = centerY-StimSize(1,2);
Y2 = centerY+StimSize(1,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  Declare coordinates of 8 points and fixation point
% %  Coordinates in pixels on 1280/1024 32 bit display
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fCenter = [centerX,centerY];
fRect = [X1,Y1,X2,Y2];
for n = 1:8
    tCenter(n*45,:) = pixs(n,:)+[centerX centerY];
    wRect(n*45,:) =  [X1+(pixs(n,1)),Y1+(pixs(n,2)),X2+(pixs(n,1)),Y2+(pixs(n,2))];
end

% Fixation times in seconds
frame1 = datain(1);  %fixation time for fixation point
frame2 = datain(2);  %fixation time for fix + target display
frame3 = datain(3);  %fixation time for target alone display
frame4 = datain(4); % fixation time on target until reward

% Trial type, 1 = visual, 2 = memory, 3 = No Saccade
trialtype = datain(5);
switch trialtype
    case 1
        totalframes = 4;
    case 2
        totalframes = 4;
    case 3
        totalframes = 3;
end
% Number of Trials
totalblocks = datain(6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate 8 random integers and * 45 for shuffled degrees for each trial
% Then generate two opposing random points in the 2nd and 3rd dimension of Seq
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RandYN = rand(totalblocks,8);
for n = 1:totalblocks
    Seq(n,:,1) = randperm(8)*45; % sample display
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate variable to store data to be saved as filenames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

white=WhiteIndex(0);
black=BlackIndex(0);

[window] = screen(0,'OpenWindow',black,[],32);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Make offscreen windows  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fixation

f = SCREEN(window,'OpenOffscreenWindow',black,[],32);
screen(f,'FillRect',white,fRect);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stimulus + Fixation (sf) and Stimulus alone (s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 45:45:360
    sf(n) = SCREEN(window,'OpenOffscreenWindow',black,[],32);
    screen(sf(n),'FillRect',white,fRect);
    screen(sf(n),'FillRect', white,wRect(n,:));
    s(n) = SCREEN(window,'OpenOffscreenWindow',black,[],32); 
    screen(s(n),'FillRect',white,wRect(n,:));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totaltrials = 8;
BreakState = 0;
BreakTwice = 0;
intertrial_interval = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

blockcounter = 1;
while (BreakState ~= 1) & (blockcounter <= totalblocks)
    trialcounter = 1;
    while (trialcounter <= totaltrials) & (BreakState ~=1)
        while 1
            BreakTwice = 0;
            FixState = 0;
            Result = 0;
            Deg = Seq(blockcounter,trialcounter);
            %  Display Fixation
            SCREEN(window,'WaitBlanking');   % Wait for the next monitor refresh cycle
            Screen('CopyWindow',f,window);   % First frame is fixation window
            breaktime = getsecs;
            %  Give subject 2 seconds to move to fixation window
            while (FixState <= 0) & ((getsecs - breaktime) < 2) & (BreakState ~=1)
                [FixState,BreakState] = CheckFixation(fCenter, FixationWindow);
            end
            %  If subject didn't get to window within 2 seconds, or break
            %  button was pushed, break out of trial
            if (FixState == 0) | (BreakState == 1)
                break;
            end
            breaktime = getsecs;
            %  Mouse must stay within fixation window for frame1 time
            while (FixState == 1) & ((getsecs - breaktime) < frame1) & (BreakState ~=1)
                [FixState,BreakState] = CheckFixation(fCenter, FixationWindow);
            end
            if (FixState == 0) | (BreakState == 1)
                break;
            end
            %  Display Fixation plus stimulus
            SCREEN(window,'WaitBlanking');       
            Screen('CopyWindow',sf(Deg),window); 
            breaktime = getsecs;
            %  Check that mouse stays within fixation window for frame2
            %  duration
            while (FixState == 1) & ((getsecs - breaktime) < frame2) & (BreakState ~=1)
                [FixState,BreakState] = CheckFixation(fCenter, FixationWindow);
            end
            if (FixState == 0) | (BreakState == 1)
                break;
            end
            %  Depending on the trial, the next frames are differ
            switch trialtype
                %  Visually guided movement
                case (1)
                    FixState = 0;
                    %  Display only stimulus
                    SCREEN(window,'WaitBlanking');       
                    Screen('CopyWindow',s(Deg),window); 
                    breaktime = getsecs;
                    %  Give subject 2 seconds to move to stimulus window
                    while (FixState == 0) & ((getsecs - breaktime) < 2) & (BreakState ~=1)
                        [FixState,BreakState] = CheckFixation(tCenter(Deg,:), FixationWindow);
                    end
                    if (FixState == 0) | (BreakState == 1)
                        BreakTwice = 1;
                        break;
                    end
                    breaktime = getsecs;
                    %  Check that mouse stays in window for frame3 time
                    while (FixState == 1) & ((getsecs - breaktime) < frame3) & (BreakState ~=1)
                        [FixState,BreakState] = CheckFixation(tCenter(Deg,:), FixationWindow);
                    end
                    if (FixState == 0) | (BreakState == 1)
                        %  If an error occurred, break out of the switch
                        %  and the while loop.
                        BreakTwice =1;
                        break;
                    end
                    %  Memory guided movement
                case(2)
                    FixState = 0;
                    %  Display an all black screen
                    SCREEN(window,'WaitBlanking');
                    Screen(window,'FillRect',black);
                    breaktime = getsecs;
                    %  Give 2 seconds to get to stimulus window
                    while (FixState == 0) & ((getsecs - breaktime) < 2) & (BreakState ~=1)
                        [FixState,BreakState] = CheckFixation(tCenter(Deg,:), FixationWindow);
                    end
                    if (FixState == 0) | (BreakState == 1)
                        BreakTwice = 1;
                        break;
                    end
                    %  Make sure mouse stays in window for frame3 time
                    breaktime = getsecs;
                    while (FixState == 1) & ((getsecs - breaktime) < frame3) & (BreakState ~=1)
                        [FixState,BreakState] = CheckFixation(tCenter(Deg,:), FixationWindow);
                    end
                    if (FixState == 0) | (BreakState == 1)
                        BreakTwice =1;
                        break;
                    end
                    %  No movement required
                case(3)
                    %  Display fixation only
                    SCREEN(window,'WaitBlanking');       
                    Screen('CopyWindow',f,window);       
                    breaktime = getsecs;
                    %  Make sure mouse stays in window for frame3 time
                    while (FixState == 1) & ((getsecs - breaktime) < frame3) & (BreakState ~=1)
                        [FixState,BreakState] = CheckFixation(fCenter, FixationWindow);
                    end
                    if (FixState == 0) | (BreakState == 1)
                        BreakTwice =1;
                        break;
                    end
                    Result = 1;
            end
            if (BreakTwice == 1) | (BreakState == 1)
                break;
            end
            %  If this point in the code is reached, the subject completed
            %  the trial successfully and Result is changed from 0 to 1
            Result = 1;
            break
        end
        Screen(window,'FillRect',black)  % Clear screen
        if Result == 1
            %  Correct auditory feedback
            SND('Play',[sin(1:500)],[2000]);
        else
            %  Incorrect auditory feedback
            SND('Play',[sin(1:500)],[1000]);
        end
        breaktime = getsecs;
        while ((getsecs - breaktime) < intertrial_interval) & (BreakState ~=1)
            [FixState,BreakState] = CheckFixation(fCenter, FixationWindow);
        end
        if (BreakState == 1)
            break;
        end
        SND('Quiet');  %  Clear soundcard buffer
        trialcounter = trialcounter + 1;
    end
    blockcounter = blockcounter + 1;
end
screen('closeall')  %  Clear all psychtoolbox screens

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [FixState,BreakState] = CheckFixation(cCenter, WindowRadius)
%  CheckFixation is a subfunction that inputs rectangular coordinates and
%  duration to check that the mouse coordinates stay within the inputed
%  rectangle for the duration and send back to the main function whether 
%  the subject was successful or errored or clicked the mouse button.  

[MouseX, MouseY, Breakbutton] = GetMouse;  % Sample mouse position and buttons
%  Compare distance from mouse coordinates from inputed window center
if (((cCenter(1,1)-MouseX)^2)+((cCenter(1,2)-MouseY)^2)) <= WindowRadius
    %  If distance between mouse and window is less than inputted radius,
    %  then mouse is in correct position
    FixState = 1;
else
    %  If not then it is outside of the radius
    FixState = 0;
end

%  Check for mouse click
if any(Breakbutton)
    %  If mouse was clicked, then send back BreakState = 1 to end the
    %  program
    BreakState = 1;
else
    BreakState = 0;
end