function video_segmentation()

%% Read video

vr = VideoReader('materialLab10/Barcelona.mp4');

assert(vr.BitsPerPixel == 24)

% For some reason, vr.NumberOfFrames is not set, so we have to use an
% approximation of the number of frames:
n_frames = ceil(vr.Duration * vr.FrameRate);

%% Read frame by frame and compute difference of histograms

% Set the if condition to false to load the history of differences instead
% of going over the entire video again
if 0
    % This can take a while. Let us display a progress bar
    h_pb = waitbar(0, '0%');

    frame = read(vr, 1);
    % We want to use the info from all the channels, so we concatenate all
    % the histograms into a single vector.
    prev_hist = cat(1, ...
        imhist(frame(:,:,1)), ...
        imhist(frame(:,:,2)), ...
        imhist(frame(:,:,3)));
    
    % The vector of histogram differecences
    history_diffs = zeros(n_frames, 1);

    ok = 1;
    frame_idx = 2;

    while ok && frame_idx <= n_frames
        done = frame_idx/n_frames;
        waitbar(done, h_pb, sprintf('%f%%', done*100))
        try
            frame = read(vr, frame_idx);
            hist = cat(1, ...
                imhist(frame(:,:,1)), ...
                imhist(frame(:,:,2)), ...
                imhist(frame(:,:,3)));
            history_diffs(frame_idx) = sum(abs(hist - prev_hist));
            prev_hist = hist;
            frame_idx = frame_idx + 1;
        catch MError
            display(getReport(MError))
            ok = 0;
        end
    end

    close(h_pb)
    
    save('history_diffs.mat', 'history_diffs')
else    
    history_diffs = load('history_diffs.mat', 'history_diffs');
    history_diffs = history_diffs.history_diffs;
end

%% Plot history of differences between frames

[peaks, shots] = findpeaks(history_diffs, 'MinPeakHeight', 2e5, 'MinPeakDistance', 10);

hold('on')
plot(1:n_frames, history_diffs)
plot(shots, peaks, 'rx')
legend('Differences', 'Shot transition', 'Location', 'Best')
title('History of consecutive histogram differences')
xlabel('Frame idx')
ylabel('Absolute difference')
hold('off')

% shots = cat(1, 1, shots); % add first frame

%% Extract frames from different shots and play


for idx=5:length(shots)-1
    display(num2str(idx))
    frames = read(vr, [shots(idx), shots(idx+1)]);
    Ibg = median(frames, 4);
    play_shot(frames, Ibg, vr.FrameRate)
end

end