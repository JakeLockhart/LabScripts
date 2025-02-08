function zap
    close all;
    handles = findall(groot, 'Type', 'figure', 'Tag', 'volshow');
    close(handles);
    clc
end