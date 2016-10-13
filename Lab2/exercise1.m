function exercise1(filename)
    % Several edge detectors are tested here.
    % In order to perform experiments faster, each detector's parameters can be
    % modified in runtime with interactive UI controls.
    % Parameters:
    %   - filename: provide name of the image, relative to the images_video
    %     directory
    if exist('../images_video','dir')
        path = '../images_video';
    elseif exist('./images_video','dir')
        path = './images_video';
    else
        error('Cannot find images_video folder')
    end
    
    img = imread([path,'/',filename]);

    if size(img,3) == 3
        img_gray = rgb2gray(img);
    else
        img_gray = img;
    end
    
    f = figure('Visible','off');
    
    controls = {};
    
    controls.general = struct(...
        'method_label', uicontrol(f,'Style','text','String','Method','Position',[20,340,100,20]),...
        'method', uicontrol(f,'Style','popup','Position',[20,360,100,20],'String',...
            {'simple','sobel','prewitt','roberts','log','zerocross','canny'},'Callback',@switchType));

    controls.simple = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20]),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0,'Callback',@findEdges));
    
    controls.sobel = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20]),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0,'Callback',@findEdges),...
        'direction_label', uicontrol(f,'Style','text','String','Direction','Position',[20,80,100,20]),...
        'direction', uicontrol(f,'Style','popup','Position',[20,100,100,20],'String',{'both','horizontal','vertical'},'Callback',@findEdges));
    
    controls.prewitt = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20]),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0,'Callback',@findEdges),...
        'direction_label', uicontrol(f,'Style','text','String','Direction','Position',[20,80,100,20]),...
        'direction', uicontrol(f,'Style','popup','Position',[20,100,100,20],'String',{'both','horizontal','vertical'},'Callback',@findEdges));
    
    controls.roberts = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20]),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0,'Callback',@findEdges));
    
    controls.log = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20]),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0,'Callback',@findEdges),...
        'sigma_label', uicontrol(f,'Style','text','Position',[20,80,300,20]),...
        'sigma', uicontrol(f,'Style','slider','Position',[20,100,300,20],'Min',0,'Max',10,'Value',2,'Callback',@findEdges));
    
    controls.zerocross = struct(...
        'thr_label', uicontrol(f,'Style','text','Position',[20,20,300,20]),...
        'thr', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0,'Callback',@findEdges),...
        'sigma_label', uicontrol(f,'Style','text','Position',[20,80,300,20]),...
        'sigma', uicontrol(f,'Style','slider','Position',[20,100,300,20],'Min',0,'Max',10,'Value',2,'Callback',@findEdges));
    
    controls.canny = struct(...
        'thr_h_label', uicontrol(f,'Style','text','Position',[20,20,300,20]),...
        'thr_h', uicontrol(f,'Style','slider','Position',[20,40,300,20],'Min',0,'Max',1,'Value',0,'Callback',@findEdges),...
        'thr_hl_ratio_label', uicontrol(f,'Style','text','Position',[20,80,300,20]),...
        'thr_hl_ratio', uicontrol(f,'Style','slider','Position',[20,100,300,20],'Min',0,'Max',0.995,'Value',0.4,'Callback',@findEdges),...
        'sigma_label', uicontrol(f,'Style','text','Position',[20,140,300,20]),...
        'sigma', uicontrol(f,'Style','slider','Position',[20,160,300,20],'Min',0,'Max',10,'Value',1,'Callback',@findEdges));
    
    switchType
    
    set(f,'Visible','on')
    
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
    
    function switchType(~,~)
        method = getPopup(controls.general.method);
        controlsetnames = fieldnames(controls);
        for idx = 1:length(controlsetnames)
            if ~strcmp(controlsetnames{idx},'general')
                setVisible(controls.(controlsetnames{idx}),'off')
            end
        end
        setVisible(controls.(method),'on')
        findEdges
    end

    function findEdges(~,~)
        method = getPopup(controls.general.method);
        switch method
            case 'simple'
                thr = get(controls.simple.thr,'Value');
                bx = imfilter(int32(img_gray),[-1,1]);
                by = imfilter(int32(img_gray),[1;-1]);
                b = bx.^2 + by.^2;
                if thr > 0
                    cutoff = (thr*255)^2;
                    set(controls.simple.thr_label,'String',['Threshold: ',num2str(thr)])
                else
                    cutoff = 2*mean2(b);
                    set(controls.simple.thr_label,'String',['Threshold: ', num2str(sqrt(cutoff)/255), '(automatic)'])
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
                    set(controls.(method).thr_label,'String',['Threshold: ',num2str(thr)])
                else
                    [edg,thr] = edge(img_gray,method,direction);
                    set(controls.(method).thr_label,'String',['Threshold: ', num2str(thr), '(automatic)'])
                end
            case 'log'
                thr = get(controls.log.thr,'Value');
                sigma = get(controls.log.sigma,'Value');
                if thr > 0
                    edg = edge(img_gray,'log',thr,sigma);
                    set(controls.log.thr_label,'String',['Threshold: ',num2str(thr)])
                else
                    [edg,thr] = edge(img_gray,'log',[],sigma);
                    set(controls.log.thr_label,'String',['Threshold: ',num2str(thr),'(automatic)'])
                end
                set(controls.log.sigma_label,'String',['Sigma: ', num2str(sigma)]);
            case 'zerocross'
                thr = get(controls.zerocross.thr,'Value');
                sigma = get(controls.zerocross.sigma,'Value');
                g = fspecial('gaussian',ceil(5*sigma),sigma);
                if thr > 0
                    edg = edge(img_gray,'zerocross',thr,g);
                    set(controls.zerocross.thr_label,'String',['Threshold: ',num2str(thr)])
                else
                    [edg,thr] = edge(img_gray,'zerocross',[],g);
                    set(controls.zerocross.thr_label,'String',['Threshold: ',num2str(thr),'(automatic)'])
                end
                set(controls.zerocross.sigma_label,'String',['Sigma: ', num2str(sigma)]);
            case 'canny'
                thr_h = get(controls.canny.thr_h,'Value');
                thr_hl_ratio = get(controls.canny.thr_hl_ratio,'Value');
                thr_l = thr_h*thr_hl_ratio;
                sigma = get(controls.canny.sigma,'Value');
                if thr_h > 0
                    edg = edge(img_gray,'canny',[thr_l,thr_h],sigma);
                    set(controls.canny.thr_h_label,'String',['High threshold: ',num2str(thr_h)]);
                    set(controls.canny.thr_hl_ratio_label,'String',['High/low threshold ratio: ',num2str(thr_hl_ratio)]);
                    
                else
                    [edg,thr] = edge(img_gray,'canny',[],sigma);
                    thr_hl_ratio = thr(1)/thr(2);
                    set(controls.canny.thr_h_label,'String',['High threshold: ',num2str(thr(2)), '(automatic)']);
                    set(controls.canny.thr_hl_ratio_label,'String',['High/low threshold ratio: ',num2str(thr_hl_ratio),'(automatic)']);
                end
                set(controls.canny.sigma_label,'String',['Sigma: ', num2str(sigma)]);
        end
        subplot(1,2,1); imshow(edg); title(['Edges with ',method,' method'])
        subplot(1,2,2); imshow(overlapEdges(img,edg,rndColor)); title('Edges overlapped to original image')
    end

end
