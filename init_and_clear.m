
close all;
clear all;

%% Set additional paths

pth0 = path;
d0=cd;
[token, d00] = strtok(fliplr(d0), '\' );
d00=fliplr(d00(2:end));
path(d00, pth0)

%% Clear Figs
set(0,'ShowHiddenHandles','on');
h = findobj;

for i=1:length(h)
try
    delete(h(i))
end
end

