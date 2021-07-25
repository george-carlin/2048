defmodule TwoOhFourEight.Game.Grid do
  @size 6

  @doc """
    returns an empty sizeXsize grid

      iex> Grid.new()
      [
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0]
      ]
  """
  def new do
    for _ <- 1..@size do
      for _ <- 1..@size do
        0
      end
    end
  end

  # Add a tile with value 'value' to a random empty cell.
  # (Assumes an empty cell can be found.)
  def add_random(grid, value) do
    {x, y} = find_empty_square(grid)
    insert_at(grid, {x, y}, value)
  end

  defp find_empty_square(grid) do
    x = :random.uniform(@size - 1)
    y = :random.uniform(@size - 1)
    if (grid |> Enum.at(y) |> Enum.at(x)) == 0 do
      {x, y}
    else
      find_empty_square(grid)
    end
  end

  @doc """
    adds value at coords x, y

      iex> grid = [[0,0], [0,0]]
      iex> Grid.insert_at(grid, {0, 1}, 2)
      [[0,0],[2,0]]
  """
  def insert_at(grid, {x, y}, value) do
    new_row = Enum.at(grid, y) |> List.replace_at(x, value)
    List.replace_at(grid, y, new_row)
  end
end
