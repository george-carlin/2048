defmodule TwoOhFourEight.Game.Game do
  defstruct [target: 2048, grid: nil, status: :in_play]

  alias TwoOhFourEight.Game.Grid

  def new() do
    %__MODULE__{
      grid: Grid.new() |> Grid.add_random(2)
    }
  end

  def shift(game, direction) when direction in [:up, :down, :left, :right] do
    IO.puts("shifting #{direction}")
    new_grid = Grid.shift(game.grid, direction)

    game_over = !Grid.can_shift?(new_grid)

    new_status = cond do
      Grid.won?(new_grid, game.target) -> :won
      game_over -> :game_over
      true -> :in_play
    end

    new_grid = if new_status == :game_over do
      new_grid
    else
      Grid.add_random(new_grid, 1)
    end

    Map.merge(game, %{
      grid: new_grid,
      status: new_status
    })
  end
end
