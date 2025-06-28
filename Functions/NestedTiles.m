function [FigureWindow, Main, Children] = NestedTiles(ParentLayout, ChildLayout, ParentDirection, ChildDirection, FigureColor)
    % NestedTiles()
    %   Creates a figure window with a nested tiled layout structure.
    %   Created by: jsl5865
    %
    % Syntax:
    %   [FigureWindow, Main, Children] = NestedTiles(ParentLayout, ChildLayout, ParentDirection, ChildDirection, FigureColor)
    %
    % Description:
    %   This function creates a figure window with a main tiledlayout (ParentLayout) based on a given number of rows or columns.
    %       Each tile within this parent layout is replaced with a UIPanel that contains a secondary tiledlayout (ChildLayout) 
    %       which allows for nesting tiledlayouts within one another.
    %
    % Inputs:
    %   ParentLayout    - Integer scalar specifying the number of tiles in the main layout.
    %   ChildLayout     - Cell array of positive integers specifying the number of tiles in each child tiled layout. Must have the same length as ParentLayout.
    %   ParentDirection - "HorizontalLayout" or "VerticalLayout", specifying the arrangement direction of the parent tiled layout.
    %   ChildDirection  - "HorizontalLayout" or "VerticalLayout", specifying the arrangement direction of the child tiled layouts.
    %   FigureColor     - 1x3 RGB vector specifying the background color for each UIPanel that contains the child tiled layouts. Default is [0.94 0.94 0.94].
    %
    % Outputs:
    %   FigureWindow   - Handle to the created figure window.
    %   Main           - Handle to the parent tiled layout object.
    %   Children       - Array of handles to the child tiled layout objects within each UIPanel.
    %
    % Example:
    %   Create a figure with 3 vertical tiles, where each tile contains a horizontal child layout with different number of tiles:
    %       ParentLayout = 3;
    %       ChildLayout = {4, 2, 3};
    %       [fig, main, children] = NestedTiles(ParentLayout, ChildLayout, "VerticalLayout", "HorizontalLayout", [1 1 1]);


    arguments
        ParentLayout (1,1) {mustBeInteger, mustBePositive}
        ChildLayout (1,:) cell {mustBeEqualSize(ChildLayout, ParentLayout)}
        ParentDirection (1,1) string {mustBeMember(ParentDirection, ["HorizontalLayout", "VerticalLayout"])} = "VerticalLayout"
        ChildDirection (1,1) string {mustBeMember(ChildDirection, ["HorizontalLayout", "VerticalLayout"])} = "HorizontalLayout"
        FigureColor (1,3) double = [0.9400 0.9400 0.9400]
    end

    FigureWindow = figure;
    set(gcf, 'Color', [0, 0, 0])

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
        Tile = uipanel(FigureWindow, "Position", TilePosition, "BorderType", "none", "BackgroundColor", FigureColor);
        
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