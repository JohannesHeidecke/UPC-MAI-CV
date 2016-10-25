% Computational Vision
% Student names: ...
%
% >> OBJECTIVE:
% 1) Write the code for Exercise 3
% 2) Execute the code and check the results
% 3) Comment the experiments and results in a report

% main
function FD_ex2()
clc; close all; clear;

%% Initialization
% Initialize the vector for storing the detection rate for each frame
detection_rate = [];

%% Detection over a video sequence (100 frames)

% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();
videoFileReader = vision.VideoFileReader('Black_or_White_face_Morphing.mp4');

while ~isDone(videoFileReader)

    % Extract the next video frame
    % >> code here <<
    
    
    % Select a video frame and run the detector.    
    % >> code here <<
    
    
    % Draw the returned bounding box around the detected face.
    % >> code here <<
    
end



end















