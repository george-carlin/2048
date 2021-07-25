defmodule TwoOhFourEight.Game.Grid.RowTest do
  use ExUnit.Case, async: true

  alias TwoOhFourEight.Game.Grid.Row

  doctest Row

  describe "shift_left/1" do
    test "no obstacles, no merging" do
      assert Row.shift_left([]) == []
      assert Row.shift_left([1]) == [1]
      assert Row.shift_left([1,2]) == [1,2]
      assert Row.shift_left([0,0,1,0,2,0]) == [1,2,0,0,0,0]
      assert Row.shift_left([0,0,0,0]) == [0,0,0,0]
    end

    test "no obstacles, with merging" do
      assert Row.shift_left([1, 1]) == [2,0]
      assert Row.shift_left([1,2,2,2,4,1,1]) == [1,4,2,4,2,0,0]
      assert Row.shift_left([0,0,1,0,1,2,4,0,0,4,64,1]) == [2,2,8,64,1,0,0,0,0,0,0,0]
    end

    test "with obstacles" do
      assert Row.shift_left([-1]) == [-1]
      assert Row.shift_left([-1,-1,-1]) == [-1,-1,-1]
      assert Row.shift_left([0,0,-1,0,-1,0,0,0]) == [0,0,-1,0,-1,0,0,0]
      assert Row.shift_left([0,1,-1,4,-1,0,128,0,64]) == [1,0,-1,4,-1,128,64,0,0]
      assert Row.shift_left([-1,0,0,2,2,-1,0,8,8,8,0,64]) ==
        [-1,4,0,0,0,-1,16,8,64,0,0,0]
    end
  end

  test "Row.Chunk.shift_left/1" do
    # No merge required:
    assert Row.Chunk.shift_left([]) == []
    assert Row.Chunk.shift_left([0]) == [0]
    assert Row.Chunk.shift_left([1]) == [1]
    assert Row.Chunk.shift_left([0,0,0,0]) == [0,0,0,0]
    assert Row.Chunk.shift_left([1,0,0,0]) == [1,0,0,0]
    assert Row.Chunk.shift_left([0,0,0,128]) == [128,0,0,0]
    assert Row.Chunk.shift_left([0,0,4,0]) == [4,0,0,0]
    assert Row.Chunk.shift_left([1,4,0,2]) == [1,4,2,0]
    assert Row.Chunk.shift_left([0,2,4,0]) == [2,4,0,0]
    assert Row.Chunk.shift_left([1,2,4,8]) == [1,2,4,8]

    # with merge:
    assert Row.Chunk.shift_left([1,1,2,2]) == [2,4,0,0]
    assert Row.Chunk.shift_left([0,1,0,1]) == [2,0,0,0]
    assert Row.Chunk.shift_left([32,32,32,32]) == [64,64,0,0]
    assert Row.Chunk.shift_left([1,2,2,2]) == [1,4,2,0]
    assert Row.Chunk.shift_left([0,0,8,8]) == [16,0,0,0]
  end
end
