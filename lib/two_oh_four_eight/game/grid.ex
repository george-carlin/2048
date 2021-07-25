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

  @doc """
    iex> Grid.can_shift?([[1,0],[0,0]])
    true
    iex> Grid.can_shift?([[1,2],[3,4]])
    false
  """
  def can_shift?(grid) do
    Enum.any?([:up, :down, :left, :right], fn dir ->
      shift(grid, dir) != grid
    end)
  end

  @doc """
    iex> Grid.won?([[0,0],[0,2048]],2048)
    true
    iex> Grid.won?([[0,0],[0,1024]],2048)
    false
  """
  def won?(grid, target) do
    Enum.any?(grid, fn row ->
      Enum.any?(row, & &1 >= target)
    end)
  end

  # Add a tile with value 'value' to a random empty cell.
  # (Assumes an empty cell can be found.)
  def add_random(grid, value) do
    case find_empty_squares(grid) do
      [] -> nil # TODO handle error
      coords ->
        {x, y} = Enum.at(
          coords,
          :random.uniform(length(coords)) - 1
        )
        insert_at(grid, {x, y}, value)
    end
  end

  # Returns list of coordinates of all empty squares
  defp find_empty_squares(grid) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.reduce([], fn
        {0, x}, acc -> [{x, y} | acc]
        {_, _}, acc -> acc
      end)
    end)
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
    IO.puts("shifting left")
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
    compacted ++ zeroes(length(row) - length(compacted))
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
