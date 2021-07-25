defmodule TwoOhFourEight.Game.Game do
  defstruct [target: 2048, grid: nil, status: :in_play, newest_tile: {-1, -1}]

  alias TwoOhFourEight.Game.Grid

  def new() do
    {grid, newest_tile} = Grid.new() |> Grid.add_tile(2)
    %__MODULE__{
      grid: grid,
      newest_tile: newest_tile
    }
  end

  def move(game, direction) when direction in [:up, :down, :left, :right] do
    {new_grid, newTileCoords} =
      game.grid
      |> Grid.move(direction)
      |> add_tile_if_changed(game.grid)

    new_status = cond do
      Grid.won?(new_grid, game.target) -> :won
      !Grid.can_move?(new_grid) -> :game_over
      true -> :in_play
    end

    Map.merge(game, %{
      grid: new_grid,
      status: new_status,
      newest_tile: newTileCoords
    })
  end

  defp add_tile_if_changed(grid, grid), do: {grid, {-1,-1}}

  defp add_tile_if_changed(moved, _original), do: Grid.add_tile(moved, 1)
end
