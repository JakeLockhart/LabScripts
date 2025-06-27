function [FigureWindow, Main, Children] = NestedTiles(ParentLayout, ChildLayout, ParentDirection, ChildDirection)
    arguments
        ParentLayout (1,1) {mustBeInteger, mustBePositive}
        ChildLayout (1,:) cell {mustBeEqualSize(ChildLayout, ParentLayout)}
        ParentDirection (1,1) string {mustBeMember(ParentDirection, ["HorizontalLayout", "VerticalLayout"])} = "HorizontalLayout"
        ChildDirection (1,1) string {mustBeMember(ChildDirection, ["HorizontalLayout", "VerticalLayout"])} = "VerticalLayout"
    end

    FigureWindow = figure;

    switch ParentDirection
        case "VerticalLayout"
            Main = tiledlayout(FigureWindow, ParentLayout, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
        case "HorizontalLayout"
            Main = tiledlayout(FigureWindow, 1, ParentLayout, 'TileSpacing', 'compact', 'Padding', 'compact');
    end

    Children = gobjects(1, ParentLayout);

    for i = 1:ParentLayout
        ax = nexttile(Main, i);
        TilePosition = ax.Position;
        delete(ax)
        Tile = uipanel(FigureWindow, "Position", TilePosition);
        
        switch ChildDirection
            case "VerticalLayout"
                Children(i) = tiledlayout(Tile, ChildLayout{i}, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
            case "HorizontalLayout"
                Children(i) = tiledlayout(Tile, 1, ChildLayout{i}, 'TileSpacing', 'compact', 'Padding', 'compact');
        end
    end


end

function mustBeEqualSize(CellArray, ExpectedSize)
    if length(CellArray) ~= ExpectedSize
        error('ChildLayout must have the same number of elements as ParentLayout.')
    end
end