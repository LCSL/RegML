function [X,Y] = loadXY(XYdata)
% reads both inputs and outputs from the same file
if ~isfield(XYdata,'labels'); XYdata.labels = 1; end
if isnumeric(XYdata.labels); % read X and Y from same file
    data = load(XYdata.datafile);
%     fields = fieldnames(data);
    % determines if it is a mat file, which means that Xtot is  a struct
    if or(strcmp(XYdata.datafile((length(XYdata.datafile)-3):end),'.mat'),exist([XYdata.datafile '.mat'],'file'));  
        fields = fieldnames(data);

        % reads from mat file
        Xtot = getfield(data,fields{1});
        if min(size(Xtot))==1; 
            Ytot = Xtot;
            Xtot = getfield(data,fields{2});
        else
            Ytot = getfield(data,fields{2});
        end
    if size(Ytot,1)==1; Ytot = Ytot'; end
    if size(Xtot,2)==length(Ytot); Xtot = Xtot'; end
    else %X and Y are merged into a matrix
         if isfield(XYdata,'rotate');
            if XYdata.rotate; 
                data = data'; 
            end
            size(data)
        end
        if XYdata.labels; % labels are the first column
            Ytot = data(:,1);
            Xtot = data(:,2:end);
        else % labels are the last column
            Ytot = data(:,end);
            Xtot = data(:,1:end-1);
        end        
    end
else % read X and Y from different files
    Xtot = load(XYdata.datafile);
    % determines if it is a mat file, which means that Xtot is  a struct
    if or(strcmp(XYdata.datafile((length(XYdata.datafile)-3):end),'.mat'),exist([XYdata.datafile '.mat'],'file'));  
        fields = fieldnames(Xtot);
        Xtot = getfield(Xtot,fields{1});
    end
    Ytot = load(XYdata.labels);
    if or(strcmp(XYdata.labels((length(XYdata.labels)-3):end),'.mat'),exist([XYdata.labels '.mat'],'file'));  
        fields = fieldnames(Ytot);
        Ytot = getfield(Ytot,fields{1});
    end        
    if size(Ytot,1)==1; Ytot = Ytot'; end
    if size(Xtot,2)==length(Ytot); Xtot = Xtot'; end
end

X = Xtot(Ytot~=0,:);
Y = Ytot(Ytot~=0);
