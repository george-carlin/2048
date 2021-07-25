defmodule TwoOhFourEight.Game.GridTest do
  use ExUnit.Case, async: true

  alias TwoOhFourEight.Game.Grid

  doctest Grid

  describe "add_random/2" do
    test "adds a random value to an empty square" do
      result = Grid.add_random([
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0]
      ], 2)

      number_of_twos =
        fn grid ->
          Enum.map(grid, fn row -> Enum.count(row, & &1 == 2) end) |> Enum.sum()
        end

      assert number_of_twos.(result) == 1

      result = Grid.add_random(result, 2)
      assert number_of_twos.(result) == 2

      result = Grid.add_random(result, 2)
      assert number_of_twos.(result) == 3
    end
  end
end
