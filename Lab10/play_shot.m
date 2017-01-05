function play_shot(frames, Ibg, fr)
    subplot(2,2,3); imshow(Ibg); title('Background')
    n_frames = size(frames, 4);
    for frame_idx=1:n_frames
        shot = frames(:,:,:,frame_idx);
        subplot(2,1,1); imshow(shot); title(['Frame ', num2str(frame_idx)])
        subplot(2,2,4); imshow(imabsdiff(shot, Ibg)); title('Movement')
        pause(1/fr)
    end
end