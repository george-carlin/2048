defmodule TwoOhFourEight.Game.RowTest do
  use ExUnit.Case, async: true

  alias TwoOhFourEight.Game.Row

  doctest Row

  describe "split/1" do
    test "splits row into chunks" do
      assert Row.split([]) == [[]]

      assert Row.split([1]) == [[1]]

      assert Row.split([-1]) == [[],[]]

      assert Row.split([0,0,0,0]) == [[0,0,0,0]]

      assert Row.split([0,-1,0,0]) == [[0], [0,0]]

      assert Row.split([-1,4,-1,2,0]) == [[], [4], [2,0]]

      assert Row.split([-1,4,-1,2,0,-1]) == [[], [4], [2,0], []]

      assert Row.split([-1,-1,-1,-1]) == [[],[],[],[],[]]

      assert Row.split([2,-1,4,8,-1]) == [[2], [4,8], []]

      assert Row.split([0,0,0,0,-1]) == [[0,0,0,0], []]
    end
  end

  describe "shift" do
    test "no obstacles, no merging" do
      assert Row.shift([]) == []
      assert Row.shift([1]) == [1]
      assert Row.shift([1,2]) == [1,2]
      assert Row.shift([0,0,1,0,2,0]) == [1,2,0,0,0,0]
      assert Row.shift([0,0,0,0]) == [0,0,0,0]
    end

    test "no obstacles, with merging" do
      assert Row.shift([1, 1]) == [2,0]
      assert Row.shift([1,2,2,2,4,1,1]) == [1,4,2,4,2,0,0]
      assert Row.shift([0,0,1,0,1,2,4,0,0,4,64,1]) == [2,2,8,64,1,0,0,0,0,0,0,0]
    end

    test "with obstacles" do
      assert Row.shift([-1]) == [-1]
      assert Row.shift([-1,-1,-1]) == [-1,-1,-1]
      assert Row.shift([0,0,-1,0,-1,0,0,0]) == [0,0,-1,0,-1,0,0,0]
      assert Row.shift([0,1,-1,4,-1,0,128,0,64]) == [1,0,-1,4,-1,128,64,0,0]
      assert Row.shift([-1,0,0,2,2,-1,0,8,8,8,0,64]) ==
        [-1,4,0,0,0,-1,16,8,64,0,0,0]
    end
  end

  test "Row.Chunk.shift/1" do
    # No merge required:
    assert Row.Chunk.shift([]) == []
    assert Row.Chunk.shift([0]) == [0]
    assert Row.Chunk.shift([1]) == [1]
    assert Row.Chunk.shift([0,0,0,0]) == [0,0,0,0]
    assert Row.Chunk.shift([1,0,0,0]) == [1,0,0,0]
    assert Row.Chunk.shift([0,0,0,128]) == [128,0,0,0]
    assert Row.Chunk.shift([0,0,4,0]) == [4,0,0,0]
    assert Row.Chunk.shift([1,4,0,2]) == [1,4,2,0]
    assert Row.Chunk.shift([0,2,4,0]) == [2,4,0,0]
    assert Row.Chunk.shift([1,2,4,8]) == [1,2,4,8]

    # with merge:
    assert Row.Chunk.shift([1,1,2,2]) == [2,4,0,0]
    assert Row.Chunk.shift([0,1,0,1]) == [2,0,0,0]
    assert Row.Chunk.shift([32,32,32,32]) == [64,64,0,0]
    assert Row.Chunk.shift([1,2,2,2]) == [1,4,2,0]
    assert Row.Chunk.shift([0,0,8,8]) == [16,0,0,0]
  end
end
