function [FigureWindow, Main, Children] = NestedTiles(ParentLayout, ChildLayout, ParentDirection, ChildDirection)
    % NestedTiles()
    %   Create a nested tiledlayout for a figure window
    %   Created by: jsl5865
    % Syntax:
    %   [FigureWindow, Main, Children] = NestedTiles(ParentLayout, ChildLayout, ParentDirection, ChildDirection)
    % Description:
    %   
    % Input: 
    %   ParentLayout - 
    %   ChildLayout - 
    %   ParentDirection - 
    %   ChildDirection - 
    % Output:
    %   FigureWindow - 
    %   Main - 
    %   Children - 

    arguments
        ParentLayout (1,1) {mustBeInteger, mustBePositive}
        ChildLayout (1,:) cell {mustBeEqualSize(ChildLayout, ParentLayout)}
        ParentDirection (1,1) string {mustBeMember(ParentDirection, ["HorizontalLayout", "VerticalLayout"])} = "VerticalLayout"
        ChildDirection (1,1) string {mustBeMember(ChildDirection, ["HorizontalLayout", "VerticalLayout"])} = "HorizontalLayout"
    end

    FigureWindow = figure;

    switch ParentDirection
        case "HorizontalLayout"
            Main = tiledlayout(FigureWindow, ParentLayout, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
        case "VerticalLayout"
            Main = tiledlayout(FigureWindow, 1, ParentLayout, 'TileSpacing', 'compact', 'Padding', 'compact');
    end

    Children = gobjects(1, ParentLayout);

    for i = 1:ParentLayout
        ax = nexttile(Main, i);
        TilePosition = ax.Position;
        delete(ax)
        Tile = uipanel(FigureWindow, "Position", TilePosition, "BorderType", "none", "BackgroundColor", FigureWindow.Color);
        
        switch ChildDirection
            case "HorizontalLayout"
                Children(i) = tiledlayout(Tile, ChildLayout{i}, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
            case "VerticalLayout"
                Children(i) = tiledlayout(Tile, 1, ChildLayout{i}, 'TileSpacing', 'compact', 'Padding', 'compact');
        end
    end


end

function mustBeEqualSize(CellArray, ExpectedSize)
    if length(CellArray) ~= ExpectedSize
        error('ChildLayout must have the same number of elements as ParentLayout.')
    end
end