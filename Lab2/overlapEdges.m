function Iout = overlapEdges(Iin,Ibw,varargin)
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

