function color = rndColor(varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    C = 3;
    if nargin > 0
        C = varargin{1};
    end
    color = uint8(round(255*rand(1,C)));
end

