defmodule TwoOhFourEight.Game.GridTest do
  use ExUnit.Case, async: true

  alias TwoOhFourEight.Game.Grid

  doctest Grid

  describe "new/1" do
    test "creates a grid with N random obstacles" do
      result = Grid.new()
      assert result |> List.flatten() |> Enum.all?(& &1 == 0)

      result = Grid.new(obstacles: 3)
      num_obstacles =
        Enum.map(result, fn row ->
          Enum.count(row, & &1 < 0)
        end)
        |> Enum.sum()

      assert num_obstacles == 3
    end
  end

  describe "add_tile/2" do
    test "adds a random value to an empty tile" do
      {result, _} = Grid.add_tile([
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

      {result,_ } = Grid.add_tile(result, 2)
      assert number_of_twos.(result) == 2

      {result, _} = Grid.add_tile(result, 2)
      assert number_of_twos.(result) == 3

      # Only one possible tile:
      {result, _} = Grid.add_tile([[1,0], [2,1]], 1)
      assert result == [[1,1], [2,1]]
    end
  end

  describe "move/2" do
    test "left" do
      assert Grid.move([
        [0,0,0,0,0,0],
        [1,0,0,0,0,0],
        [2,4,8,16,32,1],
        [1,0,2,0,0,1],
        [32,2,0,4,0,1],
        [1,2,2,0,1,1]
      ], :left) == [
        [0,0,0,0,0,0],
        [1,0,0,0,0,0],
        [2,4,8,16,32,1],
        [1,2,1,0,0,0],
        [32,2,4,1,0,0],
        [1,4,2,0,0,0]
      ]

      assert Grid.move([
        [32,32,4,4,1,2],
        [0,2,2,0,0,0],
        [2,2,2,1,1,1],
        [2,2,2,2,2,2],
        [0,2,0,2,0,2],
        [1,2,0,2,0,2]
      ], :left) == [
        [64,8,1,2,0,0],
        [4,0,0,0,0,0],
        [4,2,2,1,0,0],
        [4,4,4,0,0,0],
        [4,2,0,0,0,0],
        [1,4,2,0,0,0]
      ]
    end

    test "right" do
      assert Grid.move([
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 1],
        [1, 32, 16, 8, 4, 2],
        [1, 0, 0, 2, 0, 1],
        [1, 0, 4, 0, 2, 32],
        [1, 1, 0, 2, 2, 1]
      ], :right) == [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 1],
        [1, 32, 16, 8, 4, 2],
        [0, 0, 0, 1, 2, 1],
        [0, 0, 1, 4, 2, 32],
        [0, 0, 0, 2, 4, 1]
      ]

      assert Grid.move([
        [2, 1, 4, 4, 32, 32],
        [0, 0, 0, 2, 2, 0],
        [1, 1, 1, 2, 2, 2],
        [2, 2, 2, 2, 2, 2],
        [2, 0, 2, 0, 2, 0],
        [2, 0, 2, 0, 2, 1]
      ], :right) ==
        [
          [0, 0, 2, 1, 8, 64],
          [0, 0, 0, 0, 0, 4],
          [0, 0, 1, 2, 2, 4],
          [0, 0, 0, 4, 4, 4],
          [0, 0, 0, 0, 2, 4],
          [0, 0, 0, 2, 4, 1]
        ]
    end

    test "up" do
      assert Grid.move([
        [0, 1, 2, 1, 32, 1],
        [0, 0, 4, 0, 2, 2],
        [0, 0, 8, 2, 0, 2],
        [0, 0, 16, 0, 4, 0],
        [0, 0, 32, 0, 0, 1],
        [0, 0, 1, 1, 1, 1]
      ], :up) == [
        [0, 1, 2, 1, 32, 1],
        [0, 0, 4, 2, 2, 4],
        [0, 0, 8, 1, 4, 2],
        [0, 0, 16, 0, 1, 0],
        [0, 0, 32, 0, 0, 0],
        [0, 0, 1, 0, 0, 0]
      ]

      assert Grid.move([
        [32, 0, 2, 2, 0, 1],
        [32, 2, 2, 2, 2, 2],
        [4, 2, 2, 2, 0, 0],
        [4, 0, 1, 2, 2, 2],
        [1, 0, 1, 2, 0, 0],
        [2, 0, 1, 2, 2, 2]
      ], :up) == [
        [64, 4, 4, 4, 4, 1],
        [8, 0, 2, 4, 2, 4],
        [1, 0, 2, 4, 0, 2],
        [2, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0]
      ]
    end

    test "down" do
      assert Grid.move([
        [0, 0, 1, 1, 1, 1],
        [0, 0, 32, 0, 0, 1],
        [0, 0, 16, 0, 4, 0],
        [0, 0, 8, 2, 0, 2],
        [0, 0, 4, 0, 2, 2],
        [0, 1, 2, 1, 32, 1]
      ], :down) == [
        [0, 0, 1, 0, 0, 0],
        [0, 0, 32, 0, 0, 0],
        [0, 0, 16, 0, 1, 0],
        [0, 0, 8, 1, 4, 2],
        [0, 0, 4, 2, 2, 4],
        [0, 1, 2, 1, 32, 1]
      ]

      assert Grid.move([
        [2, 0, 1, 2, 2, 2],
        [1, 0, 1, 2, 0, 0],
        [4, 0, 1, 2, 2, 2],
        [4, 2, 2, 2, 0, 0],
        [32, 2, 2, 2, 2, 2],
        [32, 0, 2, 2, 0, 1]
      ], :down) == [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [2, 0, 1, 0, 0, 0],
        [1, 0, 2, 4, 0, 2],
        [8, 0, 2, 4, 2, 4],
        [64, 4, 4, 4, 4, 1]
      ]
    end
  end
end
