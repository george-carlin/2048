defmodule TwoOhFourEight.Game.Grid do
  @size 6

  alias TwoOhFourEight.Game.Grid.Row

  # Empty squares have value 0. Obstacles have value -1

  def new(opts \\ []) do
    num_obstacles = Keyword.get(opts, :obstacles, 0)

    empty_grid =
      for _ <- 1..@size do
        for _ <- 1..@size do
          0
        end
      end

    Enum.reduce(0..num_obstacles, empty_grid, fn
      0, grid -> grid
      _, grid -> add_tile(grid, -1) |> elem(0)
    end)
  end

  @doc """
    iex> Grid.can_move?([[1,0],[0,0]])
    true
    iex> Grid.can_move?([[1,2],[3,4]])
    false
  """
  def can_move?(grid) do
    Enum.any?([:up, :down, :left, :right], fn dir ->
      move(grid, dir) != grid
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
  # Returns the grid unchanged if nothing can be added.
  # Also returns the new cell's coordinates
  def add_tile(grid, value) do
    case find_empty_squares(grid) do
      [] ->
        {grid, nil}
      coords ->
        {x, y} = Enum.random(coords)
        new_grid = insert_at(grid, {x, y}, value)
        {new_grid, {x,y}}
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

  def move(grid, :left) do
    Enum.map(grid, &Row.shift_left/1)
  end

  def move(grid, :right) do
    grid
    |> flip()
    |> move(:left)
    |> flip()
  end

	def move(grid, :up) do
    grid
    |> transpose()
    |> move(:left)
    |> transpose()
	end

	def move(grid, :down) do
    grid
    |> transpose()
    |> move(:right)
    |> transpose()
	end

  # Taken from https://rosettacode.org/wiki/Matrix_transposition#Elixir
  defp transpose(matrix) do
    List.zip(matrix) |> Enum.map(&Tuple.to_list(&1))
  end

  defp flip(matrix) do
    for row <- matrix, do: Enum.reverse(row)
  end
end
