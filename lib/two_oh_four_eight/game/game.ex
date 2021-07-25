defmodule TwoOhFourEight.Game.Game do
  defstruct [target: 2048, grid: nil, status: :in_play]

  alias TwoOhFourEight.Game.Grid

  def new() do
    %__MODULE__{
      grid: Grid.new() |> Grid.add_random(2)
    }
  end

  def shift(game, direction) when direction in [:up, :down, :left, :right] do
    new_grid =
      game.grid
      |> Grid.shift(direction)
      |> add_random_if_different(game.grid)

    new_status = cond do
      Grid.won?(new_grid, game.target) -> :won
      !Grid.can_shift?(new_grid) -> :game_over
      true -> :in_play
    end

    Map.merge(game, %{
      grid: new_grid,
      status: new_status
    })
  end

  defp add_random_if_different(grid, grid), do: grid

  defp add_random_if_different(shifted, _original), do: Grid.add_random(shifted, 1)
end
