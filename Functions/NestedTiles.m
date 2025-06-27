function [FigureWindow, Main, Children] = NestedTiles(ParentLayout, ChildLayout, Direction)
    arguments
        ParentLayout (1,1) {mustBeInteger, mustBePositive}
        ChildLayout (1,:) cell {mustBeEqualSize(ChildLayout, ParentLayout)}
        Direction (1,1) string {mustBeMember(Direction, ["Row", "Column"])} = "Row"
    end

    FigureWindow = figure;

    switch Direction
        case "Column"
            Main = tiledlayout(FigureWindow, ParentLayout, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
        case "Row"
            Main = tiledlayout(FigureWindow, 1, ParentLayout, 'TileSpacing', 'compact', 'Padding', 'compact');
    end

    Children = gobjects(1, ParentLayout);

    for i = 1:ParentLayout
        ax = nexttile(Main, i);
        TilePosition = ax.Position;
        delete(ax)
        Tile = uipanel(FigureWindow, "Position", TilePosition);
        Children(i) = tiledlayout(Tile, ChildLayout{i}, 1, 'TileSpacing', 'compact');
    end


end

function mustBeEqualSize(CellArray, ExpectedSize)
    if length(CellArray) ~= ExpectedSize
        error('ChildLayout must have the same number of elements as ParentLayout.')
    end
end