function zap
    % zap()
    %   Reset workspace, figures, and command line
    %   Created by: jsl5865
    % Syntax:
    %   zap
    % Description:
    %   Close all figures
    %   Clear all variables in workspace
    %   Clear command line
    % Input: 
    %   []
    % Output:
    %   []
    close all;
    handles = findall(groot, 'Type', 'figure', 'Tag', 'volshow');
    close(handles);
    clc
    evalin('base', 'clear');
end