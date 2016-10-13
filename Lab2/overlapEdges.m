% MAI - CV
% Laboratory 1
% Exercise 1
% Deliverable by: Johannes Heidecke / Alejandro Suarez
function Iout = overlapEdges(Iin,Ibw,varargin)
    % Overlaps an edge to an image. The color of the edges can be indicated
    % as an additional third argument. If it is not given, then the colour
    % black is assumed.
    %   Iin: Input image
    %   Ibw: edges
    % Returns Iout, an image with the same bit depth than Iin and with the
    % edges from Ibw overlapped.
    C = size(Iin,3);
    if nargin > 2
        % Read color from argument list
        color = varargin{1}(:);
        assert(length(color)>=C,'#channels(color) < #channels(Iin)!')
    else
        % Use color 0 (black) by default.
        color = zeros(C,1);
    end
    
    Iout = zeros(size(Iin),class(Iin));
    for idx = 1:C
        channel = Iin(:,:,idx);
        channel(Ibw) = color(idx);
        Iout(:,:,idx) = channel;
    end
    
end

