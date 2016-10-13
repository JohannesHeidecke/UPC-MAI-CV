% MAI - CV
% Laboratory 1
% Exercise 1
% Deliverable by: Johannes Heidecke / Alejandro Suarez
function exercise2(filename, offset, duration)
% Reproduce a video overlapping the detected edges.
%   - offset: start time in seconds. Set to [] or to 0 to start from the begining.
%   - duration: in seconds. Process and reproduces just this duration of
%     the video, relative to the offset. Set to [] to reach the end of the 
%     video.
    if exist('../images_video','dir')
        path = '../images_video';
    elseif exist('./images_video','dir')
        path = './images_video';
    else
        error('Cannot find images_video folder')
    end
    
    vr = VideoReader([path,'/',filename]);
    
    if isempty(offset)
        offset = 0;
    end
    
    if isempty(duration)
        duration = vr.Duration;
    end
    
    assert(vr.BitsPerPixel==24, ['Depth=',num2str(vr.BitsPerPixel), '~=24'])
    
    firstFrame = 1+floor(offset*vr.FrameRate);
    nFrames = ceil(duration*vr.FrameRate);
    
    hf = figure('Visible','off','Position',[150,150,vr.Width,vr.Height]);
    hi = imshow(read(vr,firstFrame));
    set(hi,'EraseMode','xor')
    controls = getControls(hf,@start);
    set(hf,'Visible','on')
    
    T = 1/vr.FrameRate;
    
    read_time = zeros(nFrames,1);
    read_process_time = zeros(nFrames,1);
    spent = zeros(nFrames,1);
    
    function start(src,~)
        set(src,'Visible','off')
        for idx = 1:nFrames;
            tic
            frame = read(vr,firstFrame+idx-1);
            read_time(idx) = toc;
            frame_edges = findEdges(controls,frame);
            read_process_time(idx) = toc;
            set(hi,'cdata',frame_edges);
            spent(idx) = toc;
            if T-spent(idx) > 0.01
                pause(T-spent(idx));
            end
        end
        set(src,'Visible','on')

        mean_read = mean(read_time);
        mean_read_process = mean(read_process_time);
        mean_spent = mean(spent);
        mean_process = mean_read_process - mean_read;
        mean_draw = mean_spent - mean_read_process;
        display(['Mean time to read a frame: ',num2str(mean_read)])
        display(['Mean time to process a frame: ',num2str(mean_process)])
        display(['Mean time to copy a frame to the draw buffer: ',num2str(mean_draw)])
        display(['Mean time to read, process, and draw a frame: ',num2str(mean_spent)])
    
    end
end

function controls = getControls(f, startmethod)
    % We create the UI controls here.
    %   - f: handle of the figure where the controls should be appended
    %   - startmethod: reference to the method that should be executed
    %     when the start button is pressed.
    controls = {};
    
    controls.general = struct(...
        'method_label', uicontrol(f,'Style','text','String','Method','Position',[20,260,100,20]),...
        'method', uicontrol(f,'Style','popup','Position',[20,280,100,20],'String',...
            {'simple','sobel','prewitt','roberts','log','zerocross','canny'},'Callback',@switchType),...
         'start_btn', uicontrol(f,'Style','pushbutton','String','Start','Position',[20,320,100,20],'Callback',startmethod));

    controls.simple = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20],'String','Threshold (between 0 and 1)'),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0));
    
    controls.sobel = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20],'String','Threshold (between 0 and 1)'),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0),...
        'direction_label', uicontrol(f,'Style','text','String','Direction','Position',[20,80,100,20],'String', 'Direction'),...
        'direction', uicontrol(f,'Style','popup','Position',[20,100,100,20],'String',{'both','horizontal','vertical'}));
    
    controls.prewitt = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20],'String','Threshold (between 0 and 1)'),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0),...
        'direction_label', uicontrol(f,'Style','text','String','Direction','Position',[20,80,100,20],'String', 'Direction'),...
        'direction', uicontrol(f,'Style','popup','Position',[20,100,100,20],'String',{'both','horizontal','vertical'}));
    
    controls.roberts = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20],'String','Threshold (between 0 and 1)'),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0));
    
    controls.log = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20],'String','Threshold (between 0 and 1)'),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0),...
        'sigma_label', uicontrol(f,'Style','text','Position',[20,80,300,20],'String','Sigma (between 0 and 10)'),...
        'sigma', uicontrol(f,'Style','slider','Position',[20,100,300,20],'Min',0,'Max',10,'Value',2));
    
    controls.zerocross = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20],'String','Threshold (between 0 and 1)'),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0),...
        'sigma_label', uicontrol(f,'Style','text','Position',[20,80,300,20],'String','Sigma (between 0 and 10)'),...
        'sigma', uicontrol(f,'Style','slider','Position',[20,100,300,20],'Min',0,'Max',10,'Value',2));
    
    controls.canny = struct(...
        'thr_h_label', uicontrol(f,'Style','text','Position',[20,20,300,20],'String','High threshold (btwn 0 and 1)'),...
        'thr_h', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0),...
        'thr_hl_ratio_label', uicontrol(f,'Style','text','Position',[20,80,300,20], 'String','H/L threshold ratio (btwn 0 and 1)'),...
        'thr_hl_ratio', uicontrol(f,'Style','slider','Position',[20,100,300,20],'Min',0,'Max',0.995,'Value',0.4),...
        'sigma_label', uicontrol(f,'Style','text','Position',[20,140,300,20], 'String','Sigma (between 0 and 1) '),...
        'sigma', uicontrol(f,'Style','slider','Position',[20,160,300,20],'Min',0,'Max',10,'Value',1));
    
    switchType
    
    function switchType(~,~)
        method = getPopup(controls.general.method);
        controlsetnames = fieldnames(controls);
        for idx = 1:length(controlsetnames)
            if ~strcmp(controlsetnames{idx},'general')
                setVisible(controls.(controlsetnames{idx}),'off')
            end
        end
        setVisible(controls.(method),'on')
    end
    
end

function popup = getPopup(control)
    val = get(control,'Value');
    list = get(control,'String');
    popup = list{val};
end

function setVisible(controlset,visible)
    controlnames = fieldnames(controlset);
    for idx = 1:length(controlnames)
        set(controlset.(controlnames{idx}), 'Visible', visible)
    end
end

function Iout = findEdges(controls,Iin)
    % Find edges in Iin using the method and parameters indicated by
    % controls
    %   - controls: UI controls that indicate method and parameters 
    %   - Iin: input image
    img_gray = rgb2gray(Iin);
    method = getPopup(controls.general.method);
    switch method
        case 'simple'
            thr = get(controls.simple.thr,'Value');
            bx = imfilter(int32(img_gray),[-1,1]);
            by = imfilter(int32(img_gray),[1;-1]);
            b = bx.^2 + by.^2;
            if thr > 0
                cutoff = (thr*255)^2;
            else
                cutoff = 2*mean2(b);
            end
            edg = b>=cutoff;
        case {'sobel','prewitt','roberts'}
            thr = get(controls.(method).thr,'Value');
            if ~strcmp(method,'roberts')
                direction = getPopup(controls.(method).direction);
            else
                direction = 'both';
            end
            if thr > 0
                edg = edge(img_gray,method,thr,direction);
            else
                edg = edge(img_gray,method,direction);
            end
        case 'log'
            thr = get(controls.log.thr,'Value');
            sigma = get(controls.log.sigma,'Value');
            if thr > 0
                edg = edge(img_gray,'log',thr,sigma);
            else
                edg = edge(img_gray,'log',[],sigma);
            end
        case 'zerocross'
            thr = get(controls.zerocross.thr,'Value');
            sigma = get(controls.zerocross.sigma,'Value');
            g = fspecial('gaussian',ceil(5*sigma),sigma);
            if thr > 0
                edg = edge(img_gray,'zerocross',thr,g);
            else
                edg = edge(img_gray,'zerocross',[],g);
            end
        case 'canny'
            thr_h = get(controls.canny.thr_h,'Value');
            thr_hl_ratio = get(controls.canny.thr_hl_ratio,'Value');
            thr_l = thr_h*thr_hl_ratio;
            sigma = get(controls.canny.sigma,'Value');
            if thr_h > 0
                edg = edge(img_gray,'canny',[thr_l,thr_h],sigma);
            else
                edg = edge(img_gray,'canny',[],sigma);
            end
    end
    Iout = overlapEdges(Iin,edg,[255,0,255]);
end


