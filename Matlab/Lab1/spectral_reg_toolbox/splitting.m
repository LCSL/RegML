function sets = splitting(y, k, type)
% SPLITTING Calculate cross validation splits.
%   SETS = SPLITTING(Y, K) splits a dataset to do K-Fold Cross validation 
%   given a labels vector 'Y', the number of splits 'K'.
%   Returns a cell array of 'K' subsets of the indexes 1:n, with 
%   n=length(Y). The elements 1:n are split so that in each 
%   subset the ratio between indexes corresponding to positive elements 
%   of array 'Y' and indexes corresponding to negative elements of 'Y' is 
%   the about same as in 1:n. 
%   As default, the subsets are obtained  by sequentially distributing the 
%   elements of 1:n.
%
%   SETS = SPLITTING(Y, K, TYPE) allows to specify the 'TYPE' of the
%   splitting of the chosen from
%       'seq' - sequential split (as default)
%       'rand' - random split
%
%    Example:
%       sets = splitting(y, k);
%       sets = splitting(y, k, 'rand');
%
% See also KCV

if nargin == 2
    type = 'seq'; 
end

if k <= 0
    msgbox('Parameter k MUST be an integer greater than 0','Tips and tricks');
    return 
end

if ~(strcmpi(type, 'seq') || strcmpi(type, 'rand'))
    msgbox('type must be seq or rand','DEBUG: FOR DEVELOPERS EYES ONLY');
    return 
end
        

n = length(y);
if (k == n); % Leave-One-Out
    sets = cell(1, n);
    for i = 1:n
        sets{i} = i; 
    end
else
    sets = cell(1, k);
    
    c1 = find(y >= 0);
    c2 = find(y < 0);
    l1 = length(c1);
    l2 = length(c2);
    if strcmpi(type, 'seq')
        perm1 = 1:l1;
        perm2 = 1:l2;
    elseif strcmpi(type, 'rand')
        perm1 = randperm(l1);
        perm2 = randperm(l2);
    end;
    
    i = 1;
    while i<=l1;
        for v = 1:k;
            if i<=l1;
                sets{v} = [sets{v}; c1(perm1(i))];
                i = i+1;
            end;
        end;
    end;
    
    i = 1;
    while i<=l2;
        for v = 1:k;
            if i<=l2;
                sets{v} = [sets{v}; c2(perm2(i))];
                i = i+1;
            end;
        end;
    end;
end      
