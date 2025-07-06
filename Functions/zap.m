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
    close(findall(groot, 'Type', 'figure'));
    clc;
    evalin('base', 'clear');
end