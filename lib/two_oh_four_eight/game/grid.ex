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
  
  def shift(grid, :left) do
    Enum.map(grid, &shift_row/1)
  end

  def shift(grid, :right) do
    grid
    |> flip()
    |> shift(:left)
    |> flip()
  end

	def shift(grid, :up) do
    grid
    |> transpose()
    |> shift(:left)
    |> transpose()
	end

	def shift(grid, :down) do
    grid
    |> transpose()
    |> shift(:right)
    |> transpose()
	end

  defp shift_row(row) do
    row
    |> compact_row()
    |> merge_row()
    |> compact_row()
  end

  # Shift all tiles to the left without merging
  defp compact_row(row) do
    compacted = for tile <- row, tile > 0, do: tile 
    compacted ++ zeroes(@size - length(compacted))
  end

  defp zeroes(num) do
    Stream.cycle([0]) |> Enum.take(num)
  end

  defp merge_row(row), do: merge_row(row, [], 0)

  defp merge_row([], acc, tiles_moved) do
    Enum.reverse(acc) ++ zeroes(tiles_moved)
  end

  defp merge_row([val, val | tail], acc, tiles_moved) do
    merge_row(
      tail,
      [val*2 | acc],
      tiles_moved + 1
    )
  end

  defp merge_row([val | tail], acc, tiles_moved) do
    merge_row(
      tail,
      [val | acc],
      tiles_moved
    )
  end

  # Taken from https://rosettacode.org/wiki/Matrix_transposition#Elixir
  defp transpose(matrix) do
    List.zip(matrix) |> Enum.map(&Tuple.to_list(&1))
  end

  defp flip(matrix) do
    for row <- matrix, do: Enum.reverse(row)
  end
end
