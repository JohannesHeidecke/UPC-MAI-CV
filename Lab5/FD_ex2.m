% Computational Vision
% Student names: Johannes Heidecke and Alejandro Suarez
%
% >> OBJECTIVE:
% 1) Write the code for Exercise 3
% 2) Execute the code and check the results
% 3) Comment the experiments and results in a report

% main
function FD_ex2()
clc; close all; clear;

%% Initialization

N = 100;

% Initialize the vector for storing the detection rate for each frame
detection_rate = zeros(N,1);

%% Detection over a video sequence (100 frames)

% Create a cascade detector object.

videoReader = VideoReader('Black_or_White_face_Morphing.ogv'); % substitute .ogv by .mp4
% faceDetector = vision.CascadeObjectDetector('MinSize', [50,50]); % uncomment this

currAxes = axes;

for idx = 1:N % Just 100 frames. Otherwhise : % while hasFrame(videoReader)

    % Extract the next video frame
    frame = readFrame(videoReader);
    
    % Select a video frame and run the detector.    
    %bbox = step(faceDetector, frame); % uncomment this
    bbox = [350 250 500 300]; % comment this
    
    detection_rate(idx) = size(bbox,1);
    
    % Draw the returned bounding box around the detected face.
    
    image(frame, 'Parent', currAxes)
    
    for jdx = 1:size(bbox,1)
        rectangle('Position', bbox(jdx,:), 'EdgeColor', 'g')
    end
    
    pause(1/videoReader.FrameRate)
end

detection_percentage = sum(detection_rate)/N;

display(['Faces has been detected during a ', num2str(detection_percentage*100), '% of the time'])

end















