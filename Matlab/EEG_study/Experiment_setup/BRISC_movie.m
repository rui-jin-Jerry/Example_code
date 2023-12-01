
 function BRISC_movie
%
% Inputs (requested):
%   Participant_ID: the unique ID code for this participant, as a 'string'
%       in the format '1M0001'
%       First digit will be 1-3,
%       2nd character is M for boys (male, M) or F for girls (female, F)
%       then 4-digit unique number
%   subgroupCode: 'M' for Midline, 'E' for endline (or 'B' for baseline), as a 'string'
%   block_number: the consecutive block/run for this experiment and this participant, 1,2,3...
%
% About: this runs the main SSVEP experiment, displaying flickering checkerboards and a dynamic movie (The Wiggles).
% There are 10 conditions in the full version.
%
% Flicker freq of checkers placed on L or R side will be counterbalanced across babies. (not blocks)

%% Housekeeping
clc;
clear;
close all;

% Request input of variables:
Participant_ID = input('\n Please enter the unique 6-character participant ID/code, eg. ''1F0001'': ');
stageCode = input('\n Please enter the trial stage code, eg. ''M'' or ''E'': ');
block_number = input('\n Please enter experiment run/block number: ');

% If the Participant ID seems wrong, request again:
if length(Participant_ID) ~= 6
    fprintf('\n Participant ID/code incorrect format.')
    Participant_ID = input('\n Please enter the unique 6-character participant ID/code, eg. ''1F0001'': ');
    stageCode = input('\n Please enter the trial stage code, eg. ''M'' or ''E'': ');
    block_number = input('\n Please enter experiment run/block number: ');
end

% Pull out integer from participant ID to use to determine counterbalancing of checker frequencies:
checkerflip = str2double(Participant_ID(1));
% If that doesn't work... suggests ID code is wrong:
if isnan(checkerflip)
    fprintf('\n Participant ID/code incorrect format.')
    Participant_ID = input('\n Please enter the unique 6-character participant ID/code, eg. ''1F0001'': ');
    stageCode = input('\n Please enter the trial stage code, eg. ''M'' or ''E'': ');
    block_number = input('\n Please enter experiment run/block number: ');
end

%% Set Up Structures Used in Experiment
Par = struct(); % For experimental parameters
Res = struct(); % For results
Port = struct();% Pertaining to the serial port, for sending triggers.
Switch = struct(); % For experimental control

%% Define switches to control aspects of experiment
% (ie movies on/off, trigger port), also set aside important info about this block/participant

% Define the EXPERIMENT VERSION.
% Version 1 = full version, all condition types, OR
% Version 2 = omits double cue and no cue, no tone conditions (fewer trials)
%(Version 3 has its own separate function).
% *** There should be no need to change this here ***
Switch.ExperimentVersion = 1;

Switch.DrawMovies = false; % set to true or false to determine movie playback.

% SERIAL PORT
Port.InUse = false;         % set to true if sending triggers over serial port
Port.COMport = 'COM4';     % the COM port for the trigger box: should not change on this PC
Port.EventTriggerDuration = 0.004; % Duration, in sec, of trigger; delay before the port is flushed and set back to zero

% TEXT SIZE
textSizeToUse = 150; % Set to be very large so that it can be detected by the camera + mirror setup

% Just do quick warning if triggers are switched OFF:
if ~Port.InUse
    userResponse = input('WARNING: Serial port is OFF. No triggers will be sent. Continue? Enter y or n: ','s');
    if strcmp( userResponse, 'n' )
        error('Aborting function!');
    end
end

% Set aside unique details of this participant/block
Res.ParticipantInfo.ID = Participant_ID;
Res.ParticipantInfo.GenderSex = Participant_ID(2);
Res.ParticipantInfo.TrailStageCode = stageCode;
Res.BlockNumber = block_number;

% Work out a unique file name for this run.
% Get a date/time string for this file:
dateString = datestr(now);
dateString(dateString == ' ') =  '_';
dateString(dateString == '-') =  '_';
dateString(dateString == ':') =  '_';
%Set aside information
Res.ExperimentName = 'BRISC_movie';

% Unique file name for the data to be saved as, and full path for results storage:
Res.FileName = fullfile('/Users/ruijin/Back_up_Bgdash_Computer/MATLAB CODE/Data', ... % Full path for data file
    'data', [Participant_ID, '_', ...  % Unique participant code
    stageCode, '_', ... % The stage of the trial (M for midline or E for endline).
    Res.ExperimentName, ...
    '_',  num2str( block_number ), ... % Current block
    '_' , dateString ...
    '.mat']);

% Just abort if the file already exists
% (this should never be needed, but just in case):
if exist(Res.FileName,'file')
    userResponse = input('WARNING: Run file exists. Overwrite? Enter y or n: ','s');
    if ~strcmp( userResponse, 'y' )
        error('Aborting function! File exists!');
    end
end

% Query the machine we're running:
[~, Par.ComputerName] = system('hostname');
Par.ComputerType = computer;
% Store the version of Windows:
[~, Par.WindowsVersion] = system('ver');
% Store the version of Matlab we're running:
Par.MatlabVersion = version;

% Unify the keyboard names in case we run this on a mac:
KbName('UnifyKeyNames')
% Define escape key:
RespQuit = KbName('escape'); % Hit 'Esc' to quit/abort program.
Proceed = KbName('space');   % Press 'space' to proceed to next trial, when ready

%% Screen Initialisation
try % Enclose in a try/catch statement, in case something goes awry with the PTB functions
    
    %Shut down any lingering screens, in case they are open:
    Screen('CloseAll');
    
    AssertOpenGL;
    % Determine the max screen number, to display stimuli on.
    % We will only be using 1 screen, so this should = 0.
    Par.Disp.screenid = max(Screen ('Screens'));
    % Define background (mean luminance grey):
    Par.Disp.backgroundColour_RGB = 128;
    
    % Open onscreen window: We request a 32 bit per colour component
    % floating point framebuffer if it supports alpha-blendig. Otherwise
    % the system shall fall back to a 16 bit per colour component framebuffer:
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    Screen('Preference', 'SkipSyncTests', 1) % Uncomment this to override sync tests
    [Par.scrID, scrDim] = PsychImaging('OpenWindow', Par.Disp.screenid, Par.Disp.backgroundColour_RGB);
    
    winWidth = scrDim(3);
    winHeight = scrDim(4);
    centreX = scrDim(3)/2;
    centreY = scrDim(4)/2;
    % Store screen dimensions (pixels)
    Par.Disp.ScreenDimensions.ScreenHeightPix = winHeight;
    Par.Disp.ScreenDimensions.ScreenWidthPix = winWidth;
    
    %raise priority level
    priorityLevel=MaxPriority(Par.scrID); Priority(priorityLevel);
    
    % We use a normalized color range from now on. All color values are
    % specified as numbers between 0.0 and 1.0, instead of the usual 0 to
    % 255 range. This is more intuitive:
    Screen('ColorRange', Par.scrID, 1, 0);
    
    % Create separate variables for different colours
    blackIndex = 0;
    whiteIndex = 1;
    
    % Set the alpha-blending:
    Screen('BlendFunction', Par.scrID, GL_SRC_ALPHA, GL_ONE);
    Screen('BlendFunction', Par.scrID, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Display wait screen
    Screen('TextFont',Par.scrID, 'Arial');
    Screen('TextSize',Par.scrID, textSizeToUse);
    DrawFormattedText(Par.scrID,'Please wait...', ...
        'center', 'center', blackIndex);
    Screen('Flip', Par.scrID);
    
    %% Define stimuli
    % Set up the 6 * 6 checkerboards stimulus.
    
    % The first entry specifies how many pixels in each square.
    Par.Disp.NumCheckSquares = 6;
    
    % number of squares in row of the checkerboard.
    Par.Disp.NumPixCheckSq = floor(winWidth/4./Par.Disp.NumCheckSquares);   % make it a proportion of the screen width.
    Par.Disp.Checkerboard = double(checkerboard(Par.Disp.NumPixCheckSq, ...
        Par.Disp.NumCheckSquares/2) > 0.5);                                % make the checkerboard of just 1s and 0s (white/black)
    Par.Disp.CheckerboardSizePix = size(Par.Disp.Checkerboard);            % Set aside x,y size of checkerboard in pixels
    
    % Make checkerboard texture.
    % NOTE: we only need 1 texture for left and right; for flickering we use the rotation option in 'Drawtexture'
    CheckTex = Screen('MakeTexture',Par.scrID,Par.Disp.Checkerboard,[],[],2);
    
    % Define left and right coordinates of the checkerboards:
    centeredCheckRect(1,:) = CenterRectOnPointd(Screen('Rect', CheckTex), ...
        (Par.Disp.CheckerboardSizePix(1) +  Par.Disp.NumPixCheckSq)/2, ...    % Left side x coord: near edge of screen, but with room for cue stimulus
        centreY);                                                             % Left side y coord (centred)
    
    centeredCheckRect(2,:) = CenterRectOnPointd(Screen('Rect', CheckTex), ...
        winWidth - (Par.Disp.CheckerboardSizePix(1)+Par.Disp.NumPixCheckSq)/2, ... % Right side x coord: near screen edge, but with room for cue stimulus
        centreY);                                                                  % Right side y coord (centred)
    
    % Determine the size of the cue/reward stimulus.
    % We'll make this a border around the checks of width one checkerboard square.
    Par.Disp.CueRect = [0 0 Par.Disp.CheckerboardSizePix+Par.Disp.NumPixCheckSq];
    
    % Define the coordinates of the cue:
    centeredCueRect(1,:) = CenterRectOnPointd(Par.Disp.CueRect, ...
        (Par.Disp.CheckerboardSizePix(1) +  Par.Disp.NumPixCheckSq)/2, ... % Left side x coord: abutting edge of screen.
        centreY);                                                          % Left side y coord (centred)
    centeredCueRect(2,:) = CenterRectOnPointd(Par.Disp.CueRect, ...
        winWidth - (Par.Disp.CheckerboardSizePix(1)+Par.Disp.NumPixCheckSq)/2, ... % Right side x coord: abutting edge of screen.
        centreY);                                                                  % Right side y coord (centred)
    
    % Colour of the cue:
    Par.Disp.CueRGB = [1 0 0];
    
    %% Work out timing of task/stimuli
    
    % Define desired timing of trial events in sec
    % Note that the checkers and the movie are on screen for the entire duration of the trial
    % Initial period of fixation, flickering checkers and movie:
    Par.Timing.FixnChecksDurationPt1.uncorrected = 1.25;
    % Presentation of the cue
    Par.Timing.CueDuration.uncorrected = 0.1;
    % Break before reward period
    Par.Timing.FixnChecksDurationPt2.uncorrected = 0.15;
    % Post-cue reward period
    Par.Timing.RewardDuration.uncorrected = 3;
    % ... and the sum of all these elements.
    Par.Timing.TotalTrialDuration.uncorrected = Par.Timing.FixnChecksDurationPt1.uncorrected + ...
        Par.Timing.CueDuration.uncorrected + ...
        Par.Timing.FixnChecksDurationPt2.uncorrected + ...
        Par.Timing.RewardDuration.uncorrected;
    
    % How long between trials? Define the IMPOSED inter-trial interval here (in sec)
    % Note that loading the movie takes some time, so the actual delay will be slightly longer than this
    Par.Disp.InterTrialInterval = 0.5;
    
    % Adjust stimulus presentation durations to exact multiples of the screen
    % refresh duration
    Par.Timing.screenFrameRate = FrameRate(Par.scrID); % Get the frame rate
    Par.Timing.screenRefreshTime = 1 / FrameRate(Par.scrID); % Calculate the screen refresh duration in sec
    
    % Compute the number of frames for each stimulus event
    % Initial fixation period
    Par.Timing.FixnChecksDurationPt1.nFrames = ...
        round(Par.Timing.FixnChecksDurationPt1.uncorrected * Par.Timing.screenFrameRate);
    % Presentation of the cue
    Par.Timing.CueDuration.nFrames = ...
        round(Par.Timing.CueDuration.uncorrected * Par.Timing.screenFrameRate);
    % Break before reward period
    Par.Timing.FixnChecksDurationPt2.nFrames = ...
        round(Par.Timing.FixnChecksDurationPt2.uncorrected * Par.Timing.screenFrameRate);
    % Post-cue reward period
    Par.Timing.RewardDuration.nFrames = ...
        round(Par.Timing.RewardDuration.uncorrected * Par.Timing.screenFrameRate);
    % Sum of frames across the trial:
    Par.Timing.TotalTrialFrames = Par.Timing.FixnChecksDurationPt1.nFrames + Par.Timing.CueDuration.nFrames + ...
        Par.Timing.FixnChecksDurationPt2.nFrames + Par.Timing.RewardDuration.nFrames;
    % ...and the total duration of one trial in SEC
    Par.Timing.TotalTrialDuration.corrected = Par.Timing.TotalTrialFrames / Par.Timing.screenFrameRate;
    
    %% Set up timing duty cycles for the checkerboards.
    
    % These consist of square waves of zeros and ones that are used to
    % flip the checkerboard by 90 deg in order to cause it to reverse in contrast polarity at the appropriate frequency.
    
    % Temporal frequencies of the two checkerboards: determine left/right placing
    % based on whether the participant ID number is odd or even (method of counterbalancing across individuals).
    if mod(checkerflip,2)    % If it's an odd-numbered participant
        Par.Disp.CheckFreqHz = [6 10]; % 6 Hz on left, 10 Hz on right
        
    else                        % otherwise, if it's an even-numbered participant, do the opposite
        Par.Disp.CheckFreqHz = [10 6]; % 10 Hz on left, 6 Hz on right
    end
    
    angFreq = 2 * pi * Par.Disp.CheckFreqHz; % Periodic frequencies of our checkerboards
    % Define time points to sample our wave at (in sec):
    t = 0 : Par.Timing.screenRefreshTime : Par.Timing.TotalTrialDuration.corrected;
    % Generate the square waves for both frequencies;
    % Half-wave rectify them by adding 1 and dividing by 2 (so we have 1s and 0s, not 1s and -1s).
    Par.Disp.ChecksDutyCycles = (square(cos(angFreq.*t')) + 1) / 2;
    
    % Set up vector to control collection of timestamps of checkerboard contrast reverals:
    Par.Disp.CheckerReversalsLeft = [1; findchangepts(Par.Disp.ChecksDutyCycles(:,1), 'MaxNumChanges', length(Par.Disp.ChecksDutyCycles(:,1)))];
    Par.Disp.CheckerReversalsRight = [1; findchangepts(Par.Disp.ChecksDutyCycles(:,2), 'MaxNumChanges', length(Par.Disp.ChecksDutyCycles(:,2)))];
    % This gives us a logical array indicating when to store a timestamp for the left and right checkerboards.
    Par.Disp.CheckerReversalsLeft = ismember(1:length(Par.Disp.ChecksDutyCycles(:,1)), Par.Disp.CheckerReversalsLeft);
    Par.Disp.CheckerReversalsRight = ismember(1:length(Par.Disp.ChecksDutyCycles(:,2)), Par.Disp.CheckerReversalsRight);
    
    
    %% Set up timing duty cycles for the cue / reward stimulus.
    % Cue will be bright red border around the checkerboard (RGB= 1 0 0).
    % Here, we will also insert a flag to control the onset of the auditory tone, if any.
    %   There are 5 cue trial types:
    %   Valid | invalid | double cue | no cue + tone | no cue, no tone
    %   .. * 2 each with the reward stimulus presented on either left or right. So 10 trials.
    %   We control each trial type by modifying the RGB values of the cue/reward type stimulus on each frame.
    %   NOTE: when we insert the RGB values for the color change of the reward stimulus in a non-periodic
    %   way, we sometimes get additional frames added on the end; this is probably not an issue
    %   (these extra frames will simply not be indexed and used).
    
    % Set up a matrix encoding each of the visible conditions, where 1=present, 0=not present
    % Assign trials with reward appearing on the LEFT hand side
    % Note that the auditory tone occurs with all conditions except the last one
    %   Left side     |  Right side
    %   Cue | Reward  | Cue | Reward
    Par.Disp.ConditionMatrix = [
        1       1       0       0; ... % Valid cue, left reward
        1       0       0       1; ... % Invalid cue, left reward
        0       1       0       0; ... % Tone only, left reward
        1       1       1       0; ... % Double cue, left reward
        0       1       0       0; ... % No cues, left reward
        ];
    
    % 1 = auditory cue ON, 0 = auditory cue OFF
    Par.Disp.AuditoryCueOn = [1 1 1 1 0]; % For left cues; all are ON except trial type 5
    
    % Now, here we can remove trial types from the condition matrix if we want to use a simpler experiment.
    if Switch.ExperimentVersion == 2
        Par.Disp.ConditionMatrix = Par.Disp.ConditionMatrix(1:end-2,:); % Cut the 2 lowest conditions
        Par.Disp.AuditoryCueOn = Par.Disp.AuditoryCueOn(1:end-2);
    end
    
    % 1 = auditory cue ON, 0 = auditory cue OFF
    % Now repeat for the right side cues:
    Par.Disp.AuditoryCueOn = [Par.Disp.AuditoryCueOn, Par.Disp.AuditoryCueOn];
    
    % To set up the trials with reward on the RIGHT hand side, we can simply
    % swap columns 1&2 for 3&4 from above. Do so using circshift:
    Par.Disp.ConditionMatrix = [Par.Disp.ConditionMatrix; ...
        circshift(Par.Disp.ConditionMatrix,2,2)];
    % We now have a matrix encoding the 10 trial types (according to reward location+cue validity).
    % We can use this to set up our cuing duty cycle.
    Par.Disp.NumTrialTypes = length(Par.Disp.ConditionMatrix);
    
    % Set up grey RGB values for most of the trial (ie, invisible cue):
    Par.Timing.LeftCueStimulusRGB = repmat({ones(Par.Timing.TotalTrialFrames, 3).*0.5}, ...
        Par.Disp.NumTrialTypes, 1);
    Par.Timing.RightCueStimulusRGB = repmat({ones(Par.Timing.TotalTrialFrames, 3).*0.5}, ...
        Par.Disp.NumTrialTypes, 1);
    
    % Insert cue duration frames RGB (defined above) for both left and right sides,
    % and the randomly flickering colours of the reward stimulus.
    % Define characteristics of the reward stimulus (common to all conditions):
    minChange = 2; %minimum time of reward stim change (2 frames)
    jitterRange = round(1 * Par.Timing.screenFrameRate); % Amount of jitter in change (frames)
    
    for condN = 1:Par.Disp.NumTrialTypes % Loop across all unique trial types
        
        % Insert left side cue (if any)
        if Par.Disp.ConditionMatrix(condN,1)
            Par.Timing.LeftCueStimulusRGB{condN}(Par.Timing.FixnChecksDurationPt1.nFrames+1 : ...
                Par.Timing.FixnChecksDurationPt1.nFrames + Par.Timing.CueDuration.nFrames, :) ...
                = repmat(Par.Disp.CueRGB, Par.Timing.CueDuration.nFrames, 1);
        end
        % Insert right side cue (if any)
        if Par.Disp.ConditionMatrix(condN,3)
            Par.Timing.RightCueStimulusRGB{condN}(Par.Timing.FixnChecksDurationPt1.nFrames+1 : ...
                Par.Timing.FixnChecksDurationPt1.nFrames + Par.Timing.CueDuration.nFrames, :) ...
                = repmat(Par.Disp.CueRGB, Par.Timing.CueDuration.nFrames, 1);
        end
        
        % Insert the reward stimulus
        % Insert random RGB values across random periods to induce non-periodic colour flicker
        if Par.Disp.ConditionMatrix(condN,2)
            % First, do left hand side stimulus
            frameCount = Par.Timing.TotalTrialFrames - Par.Timing.RewardDuration.nFrames; % Reset num frames prior to reward onset
            while frameCount < Par.Timing.TotalTrialFrames
                offset = round((rand*jitterRange)+minChange);
                Par.Timing.LeftCueStimulusRGB{condN}(frameCount+1 : frameCount+offset,:) = ...
                    repmat(rand(1,3), offset, 1);
                frameCount = frameCount + offset;
            end
        end
        
        % Now do right hand side stimulus:
        if Par.Disp.ConditionMatrix(condN,4)
            frameCount = Par.Timing.TotalTrialFrames - Par.Timing.RewardDuration.nFrames; % Reset num frames prior to reward onset
            while frameCount < Par.Timing.TotalTrialFrames
                offset = round((rand*jitterRange)+minChange);
                Par.Timing.RightCueStimulusRGB{condN}(frameCount+1 : frameCount+offset,:) = ...
                    repmat(rand(1,3), offset, 1);
                frameCount = frameCount + offset;
            end
        end
    end    % End of loop across conditions
    
    %% Determine randomisation order of trials
    % Pick a random order to display the trials in. IMPORTANT! This sequence tells us in what order 1...n, the n trial types were presented in.
    % NOTE: we will not re-shuffle the movies, because they are already randomly selected, so whatever trials 1...n are presented are associated
    % with movies 1....n defined below.
    % (it probably doesn't really matter what movie is displayed anyway; we are mostly interested in the experimental trial types).
    % Note that this randomisation only determines the order of the CUING/REWARD conditions, because the checkerboards occur in each trial type.
    Par.Timing.RandomTrialOrder = randperm(Par.Disp.NumTrialTypes);
    
    %% Open the serial device for triggers (if using)
    if Port.InUse
        Port.sObj = serial(Port.COMport);
        fopen(Port.sObj);
        
        % Send a dummy pulse to initialise the device:
        send_event_trigger(Port.sObj, Port.EventTriggerDuration, 255)
    else
        Port.sObj = []; % Just use an empty object if we're not using the port
    end
    
    %% Define the event code triggers
    if Port.InUse
        Port.EventCodes = define_trigger_event_codes(Par.Disp.NumTrialTypes);
    end
    
    %% Determine parameters of each movie displayed on each trial
    % Note that these movie files all have a FPS of 25, which is close to 30, half the frame rate of the display.
    % So we will only want to display a movie image on every 2nd frame, otherwise it will look too fast/jerky.
    
    if Switch.DrawMovies
        % Generate a cell array of strings providing the full paths of each of the 9 movie files.
        % All of the Wiggles movies listed here have the same resolution: 720 (h) * 1280 (w)
        Par.Disp.video_dir = 'C:\Users\BRISC\Videos';                     % The movie file directory
        Par.Disp.MoviePaths = {'The Wiggles - Romp Bomp A Stomp.mp4', ... % Each of the movie file names
            'The Wiggles- Do The Pretzel (Official Video).mp4', ...
            'The Wiggles- Do The Propeller! (Official Video).mp4', ...
            'The Wiggles- Do the Skeleton Scat (Official Video).mp4', ...
            'The Wiggles- I''ve Got My Glasses On (Official Video).mp4', ...
            'The Wiggles- Ooey, Ooey, Ooey Allergies.mp4', ...
            'The Wiggles- Say the Dance, Do the Dance (Official Video).mp4', ...
            'The Wiggles- There Are So Many Animals (Official Video).mp4', ...
            'The Wiggles- Who''s In The Wiggle House- (Official Video).mp4'};
        % Insert the full directory into each file path
        Par.Disp.MoviePaths = cellfun(@(x) fullfile(Par.Disp.video_dir, x), Par.Disp.MoviePaths, 'UniformOutput', false);
        
        % Extract and set aside details of each of the movies:
        for v=1:length(Par.Disp.MoviePaths)
            Par.Disp.MovieDetails{v} = VideoReader(Par.Disp.MoviePaths{v});
        end
        
        Par.Disp.NumMovieFiles = length(Par.Disp.MovieDetails); % Store the number of available movie files.
        Par.Disp.ReduceMovieResBy = 1/2; % Multiplier: the proportion of original movie size that we want them shrunk down to.
    end
    
    if Switch.DrawMovies
        % We'll select a random movie and a random time period from that movie for display on each trial,
        % provided it does not exceed the end of the movie.
        
        for condN = 1:Par.Disp.NumTrialTypes
            
            %Randomly select a movie file:
            RandDraw = ceil(rand*Par.Disp.NumMovieFiles);
            
            % Set aside the name+path of the movie file to be used:
            Par.Disp.MoviesUsed.movieFileName{condN} = Par.Disp.MoviePaths{RandDraw};
            % Select a random time point from the movie, making sure it will not overlap with the end of the trial:
            Par.Disp.RandomMovieStartTime(condN) = rand*(Par.Disp.MovieDetails{RandDraw}.Duration - Par.Timing.TotalTrialDuration.uncorrected);
            
            % Determine new rect based on movie resolution, to make the movie smaller on screen.
            % All movies are displayed at the centre of the screen.
            % These will be identical for each selection, unless a new set of movies of different resolution are used.
            % But we will set aside details of each just in case...
            Par.Disp.movieRects(condN,:) = CenterRectOnPointd ([0 0 ...
                Par.Disp.MovieDetails{RandDraw}.Width * Par.Disp.ReduceMovieResBy ...
                Par.Disp.MovieDetails{RandDraw}.Height * Par.Disp.ReduceMovieResBy], ...
                centreX, centreY);
        end
    end
    
    % Here we also want to load a set of movie textures into memory, ready for display.
    % These textures will be overwritten between trials.
    % We already have our movie objects saved from above.
    % We will simply use the randomly selected movie for the first trial here.
    if Switch.DrawMovies
        % Open a new movie object, at the random start time defined above:
        movieObj = VideoReader(Par.Disp.MoviesUsed.movieFileName{1},'CurrentTime',Par.Disp.RandomMovieStartTime(1));
        % we only display an image every 2nd video refresh (hence/2)
        % This also means we don't have to hold as many images in memory.
        for k = 1 : round(Par.Timing.TotalTrialFrames / 2)
            this_frame = readFrame(movieObj);
            MovieTex(k) = Screen('MakeTexture',Par.scrID,this_frame);
        end
    end
    
    %% Set up the auditory tone for the cue:
    % We'll use matlab's sound player function for an auditory cue of 50 ms
    Par.Disp.AudioCueDuration = Par.Timing.CueDuration.uncorrected/2; % Audio duration as proportion of visual cue duration
    Par.Disp.AudioSampleRateHz = 48000;                               % This is the default for this machine
    Par.Disp.AudioBitDepth = 24;                                      % Bits per sample: default bit depth for this machine
    Par.Disp.AudioToneFreqHz = 2000;                                  % Frequency of the sine wave we want to play
    % Make the sine wave:
    Par.Disp.AudioCueWave = sin(2*pi*Par.Disp.AudioToneFreqHz* ...
        (1/Par.Disp.AudioSampleRateHz: 1/Par.Disp.AudioSampleRateHz : Par.Disp.AudioCueDuration));
    
    % Make the volume ramp for the sound, 100 ms over start/finish, so there are no harsh auditory onsets:
    Par.Disp.AudioCueVolRamp = [linspace(0,1, Par.Disp.AudioSampleRateHz*0.01), ...
        ones(1,Par.Disp.AudioSampleRateHz*0.03), linspace(1,0, Par.Disp.AudioSampleRateHz*0.01)];
    % Play the sound once, just to load the function before the experiment begins
    % (and alert the attention of the experimenter that the code is ready).
    sound( Par.Disp.AudioCueVolRamp.*Par.Disp.AudioCueWave, Par.Disp.AudioSampleRateHz, Par.Disp.AudioBitDepth);
    
    %% Save all parameters and details so far:
    save(Res.FileName, 'Par', 'Res', 'Switch', 'Port')
    
    %% Begin the experiment!
    ForcedQuit = false; % this is a flag for the exit function to indicate whether the program was aborted
    HideCursor;
    
    % Display welcome screen
    Screen('TextFont',Par.scrID, 'Arial');
    Screen('TextSize',Par.scrID, textSizeToUse); 
    DrawFormattedText(Par.scrID,['Welcome ', ...
        '\n \nPress any key to begin.', ...
        '\n \nOr press ''Esc'' to exit at any time.'], ...
        'center', 'center', blackIndex);
    Screen('Flip', Par.scrID); %, [], [], [], 1);
    
    % Wait for user response to continue...
    ButtonPressed = 0;
    while ~ButtonPressed
        % if 'Esc' is pressed, abort
        [KeyIsDown, ~, keyCode] = KbCheck();
        if KeyIsDown % a key has been pressed
            if keyCode(RespQuit)
                ForcedQuit = true
                ExitGracefully(ForcedQuit, Port.sObj)
            else %if any other button on the keyboard has been pressed, begin
                ButtonPressed = 1;
            end
        end
    end
    
    %% Initialise variables to control stimulus presentation:
    WaitSecs(0.2);
    KbCheck(); % take a quick KbCheck to load it now & flush any stored events
    
    % Blank the screen and wait 2 secs before beginning.
    Screen('Flip', Par.scrID);
    WaitSecs(2);
    Res.Timing.missedFrames = 0; % Set up counter for missed frames.
    
    % Set up empty containers for vbl timestamps: trial, cue, and reward onsets
    Res.Timing.TrialOnsetTimestamps = [];
    Res.Timing.CueOnsetTimestamps = [];
    Res.Timing.RewardOnsetTimestamps = [];
    % And for the checkerboard contrast reverals: 
    Res.Timing.CheckerContRevTimestampsLeft = cell(1,10); % empty cell arrays, 1 cell for each (potential) trial
    Res.Timing.CheckerContRevTimestampsRight = cell(1,10);
    
    trialN = 1; % Counter to increment across TRIALS
    F = 1; % Counter to increment across FRAMES
    
    % Update screen and begin
    vbl = Screen('Flip', Par.scrID);
    % Store overall block start time
    Res.Timing.blockStartTime = vbl;
    
    %% Display stimuli!
    while trialN <= Par.Disp.NumTrialTypes % Begin loop across trial types
        
        % Display trial number of screen:
        % DrawFormattedText(Par.scrID, [num2str(trialN) ',' num2str(Par.Timing.RandomTrialOrder(trialN))], ...% :to display trialNo+ trial type code
        DrawFormattedText(Par.scrID, [num2str(trialN), ...
            '\n \n Press ''space'' when ready to continue'], ...
            'center', 'center', blackIndex);
        Screen('Flip', Par.scrID);
        % Flush the keyboard buffer
        KbCheck();
        WaitSecs(0.002);
        KbCheck();
        
        % Wait for user response to continue...
        ButtonPressed = 0;
        while ~ButtonPressed
            % if 'Esc' is pressed, abort
            [KeyIsDown, ~, keyCode] = KbCheck();
            if KeyIsDown % a key has been pressed
                if keyCode(RespQuit)
                    ForcedQuit = true
                    ExitGracefully(ForcedQuit, Port.sObj)
                    
                elseif keyCode(Proceed) % If the space bar has been pressed, proceed
                    
                    %Refresh screen
                    DrawFormattedText(Par.scrID, num2str(trialN), ...
                        'center', 'center', blackIndex);
                    Screen('Flip', Par.scrID);
                    ButtonPressed = 1;
                end
            end
        end
        
        if Switch.DrawMovies
            % Open a new movie object for this trial, at the random start time defined above:
            movieObj = VideoReader(Par.Disp.MoviesUsed.movieFileName{trialN}, ...
                'CurrentTime',Par.Disp.RandomMovieStartTime(trialN));
            % we only display an image every 2nd video refresh (hence/2)
            % This also means we don't have to hold as many images in memory.
            for k = 1 : round(Par.Timing.TotalTrialFrames / 2)
                this_frame = readFrame(movieObj);
                MovieTex(k) = Screen('MakeTexture',Par.scrID,this_frame);
            end
        end
        
        % Set up the audio cue for this trial, if there is one.
        % If there is no auditory tone, the sound is set to zero.
        this_trial_sound = Par.Disp.AuditoryCueOn(Par.Timing.RandomTrialOrder(trialN)).* ...
            Par.Disp.AudioCueVolRamp.*Par.Disp.AudioCueWave;
        
        % Refresh the screen after the wait period, and take new vbl timestamp to control the ITI
        DrawFormattedText(Par.scrID, num2str(trialN), ...
            'center', 'center', blackIndex);
        [vbl , ~ , ~, ~] = Screen('Flip', Par.scrID);
        
        % Insert inter-trial interval (ITI)
        SendBlockTrigger = 0;
        SendTrialTrigger = 0;
        while GetSecs() < vbl + Par.Disp.InterTrialInterval
            
            % Send triggers prior to each trial, indicating block & trial nos.
            if Port.InUse
                % Send BLOCK no. trigger 100 ms before trial onset
                if GetSecs() > vbl + (Par.Disp.InterTrialInterval-0.1) && ~SendBlockTrigger
                    send_event_trigger(Port.sObj, Port.EventTriggerDuration, Res.BlockNumber)
                    SendBlockTrigger = 1; % This switch prevents >1 triggers being sent
                end
                % Send TRIAL no. trigger 50 ms before trial onset
                if GetSecs() > vbl + (Par.Disp.InterTrialInterval-0.05) && ~SendTrialTrigger
                    send_event_trigger(Port.sObj, Port.EventTriggerDuration, Port.EventCodes(trialN,1));
                    SendTrialTrigger = 1; % This switch prevents >1 triggers being sent
                end
            end
            
        end % end of inter-trial interval while loop
        
        % Refresh screen ready for new trial:
        [vbl , ~ , ~, ~] = Screen('Flip', Par.scrID, vbl+(Par.Timing.screenRefreshTime*0.5)); %, [], [], 1); % update display on next refresh (& provide deadline)
        
        %Determine what the correct length of the stimulus or blank should be, if this is the first frame:
        if F == 1
            trialStartVBL = vbl; %take start point as most recent vbl
            trialEndVBL = trialStartVBL + Par.Timing.TotalTrialDuration.uncorrected -  Par.Timing.screenRefreshTime;
        end
        
        % Draw each stimulus event:
        trialEnd = false;
        while ~trialEnd %This should keep iterating across stim frames until vbl >= trialEndVBL
            
            % Draw the cue + reward stimuli:
            Screen('FillRect', Par.scrID, ... % Left hand cue/reward
                Par.Timing.LeftCueStimulusRGB{Par.Timing.RandomTrialOrder(trialN)}(F,:), ...
                centeredCueRect(1,:));
            Screen('FillRect', Par.scrID, ... % Right hand cue/reward
                Par.Timing.RightCueStimulusRGB{Par.Timing.RandomTrialOrder(trialN)}(F,:), ...
                centeredCueRect(2,:));
            
            %Draw the checkerboard stimuli:
            Screen('DrawTextures', Par.scrID, ...
                CheckTex, ...                       % Index the checkerboard texture
                [], ...                             % texture subpart (we use whole texture)
                centeredCheckRect', ...             % locations of the L/R checkerboards
                Par.Disp.ChecksDutyCycles(F,:)*90); % rotation angle: determines the flickering
            
            if Switch.DrawMovies
                % Draw a movie image texture every 2nd video frame (ie ceil(frame no/2))
                Screen('DrawTexture', Par.scrID, MovieTex(ceil(F/2)), [],  Par.Disp.movieRects(trialN,:));
            end
            
            Screen('DrawingFinished', Par.scrID);
            
            [vbl , ~ , ~, missed] = Screen('Flip', Par.scrID, vbl+(Par.Timing.screenRefreshTime*0.5)); %, [], [], 1); % update display on next refresh (& provide deadline)
            
            % Set aside computer timestamps and triggers (if using)
            % trial onset, cue, reward
            if F == 1
                
                if Port.InUse
                    % send trial onset
                    send_event_trigger(Port.sObj, Port.EventTriggerDuration, ...
                        Port.EventCodes(Par.Timing.RandomTrialOrder(trialN),2)); % Col 2 of event code matrix
                end
                
                % Store trial onset timestamp:
                Res.Timing.TrialOnsetTimestamps = [Res.Timing.TrialOnsetTimestamps, vbl];
                
            elseif F == Par.Timing.FixnChecksDurationPt1.nFrames+1
                
                if Port.InUse
                    % Send cue onset
                    send_event_trigger(Port.sObj, Port.EventTriggerDuration, ...
                        Port.EventCodes(Par.Timing.RandomTrialOrder(trialN),3)); % Col 3 of event code matrix
                end
                
                % Store cue onset timestamp:
                Res.Timing.CueOnsetTimestamps = [Res.Timing.CueOnsetTimestamps, vbl];
                
                % Send reward/target onset: it occurs at the sum of the 3 prior periods
            elseif F == Par.Timing.FixnChecksDurationPt1.nFrames + ... % Fixation period
                    Par.Timing.CueDuration.nFrames + ...               % Cue period
                    Par.Timing.FixnChecksDurationPt2.nFrames + 1       % Delay after cue, before reward
                
                if Port.InUse
                    send_event_trigger(Port.sObj, Port.EventTriggerDuration, ...
                        Port.EventCodes(Par.Timing.RandomTrialOrder(trialN),4)); % Col 4 of event code matrix
                end
                
                % Store reward onset timestamp:
                Res.Timing.RewardOnsetTimestamps = [Res.Timing.RewardOnsetTimestamps, vbl];
                
            end
            
            % Set aside timestamps of checkerboard contrast reversals:
            if Par.Disp.CheckerReversalsLeft(F) % Left checkerboards
                Res.Timing.CheckerContRevTimestampsLeft{trialN} = [Res.Timing.CheckerContRevTimestampsLeft{trialN}(:); vbl];
            end
            if Par.Disp.CheckerReversalsRight(F) % Right checkerboards
                Res.Timing.CheckerContRevTimestampsRight{trialN} = [Res.Timing.CheckerContRevTimestampsRight{trialN}(:); vbl];
            end
            
            % Keep record of any missed frames
            if missed > 0
                Res.Timing.missedFrames = Res.Timing.missedFrames + 1;
            end
            
            % Check for 'Escape' key to abort
            [KeyIsDown, ~, keyCode] = KbCheck();
            if KeyIsDown % a key has been pressed
                if keyCode(RespQuit)
                    ForcedQuit = true
                    ExitGracefully(ForcedQuit, Port.sObj)
                end
            end
            
            % Increment frames.
            F = F + 1; % Only F is reset with each trial
            
            % Play audio tone when appropriate frame arrives (onset of visual cue):
            if F == Par.Timing.FixnChecksDurationPt1.nFrames+1
                sound(this_trial_sound, Par.Disp.AudioSampleRateHz, Par.Disp.AudioBitDepth);
            end
            
            % This is the important bit:
            % If we've reached the determined end time of the trial,
            % we reset F and move on to the next one.
            % This means no stimulus ever exceeds its deadline (by more than 1 frame anyway)
            % and we shouldn't miss any either.
            if vbl >= trialEndVBL
                F = 1;             % Reset F for next trial
                trialN = trialN+1; % Increment condition/ trial type
                trialEnd = true;   % This should terminate the current stimulus execution and move on to next one
            end
        end % end of loop across trial frames
        
        if Switch.DrawMovies
            % Clear some of the variables associated with the movie images
            clear('movieObj')
            clear('this_frame')
            clear('MovieTex')
        end
        
        Screen('Flip', Par.scrID); % Blank screen between trials
        
        % Save updated results file here:
        save(Res.FileName, 'Par', 'Res', 'Switch', 'Port')
        
    end % end of loop across trial types
    
catch MException
    
    % We throw the error again so the user sees the error description.
    rethrow (MException)
    psychrethrow(psychlasterror);
    ExitGracefully (ForcedQuit, Port.sObj)
    error('Error!')
    
end % End of try/catch statement.

Screen('CloseAll')
% Print out number of missed frames to command window:
fprintf('\nWe counted %d missed frames in this block',Res.Timing.missedFrames)
% Close down and exit:
ExitGracefully (ForcedQuit, Port.sObj)

end % End of main function

%% Sub-functions follow..
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ExitGracefully (ForcedQuit, serial_object)
%...need to shut everything down here...

% turn off the prioritisation:
Priority( 0 ); % restore priority

% Close down the screen:
Screen('CloseAll')

% Bring back the mouse cursor:
ShowCursor();

% Close down the serial port (if used)
if ~isempty(serial_object)
    fclose(serial_object);
end

% announce to cmd window if the program was aborted by the user
if ForcedQuit
    error('You quit the program!')
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EventCodesMatrix = define_trigger_event_codes (num_trials)
% Define the trigger event codes to be sent to the serial port
% Each row is a condition/trial type (1:n), and each column is for trial numbers (consecutive order of presentation),
% trial onsets, cue onsets, and reward/target onsets,
% respectively.

EventCodesMatrix = [(101:100+num_trials)' ...% Consecutive trial number
    (51:50+num_trials)', ...                 % Trial start+condition code
    (151:150+num_trials)', ...               % Cue onset+condition code
    (201:200+num_trials)' ...                % Reward/target onset+condition code
    ];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function send_event_trigger(serial_object, trigger_duration, event_code)
% Send a trigger over the serial port, as defined in 'event_code'
% There is an imposed delay (duration) of 'trigger_duration' seconds
% and then the port is flushed again with zero, ready for next use.

fwrite(serial_object, event_code);
WaitSecs(trigger_duration);
fwrite(serial_object, 0);

end


