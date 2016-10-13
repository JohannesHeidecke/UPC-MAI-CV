% MAI - CV
% Laboratory 1
% Exercise 1
% Deliverable by: Johannes Heidecke / Alejandro Suarez
function color = rndColor(varargin)
% Returns a random color. The number of channels can be given as an
% optional numeric argument. If it is not given, then the number of
% channels is assumed to be 3.
    C = 3;
    if nargin > 0
        C = varargin{1};
    end
    color = uint8(round(255*rand(1,C)));
end

