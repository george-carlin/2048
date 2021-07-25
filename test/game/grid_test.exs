defmodule TwoOhFourEight.Game.GridTest do
  use ExUnit.Case, async: true

  alias TwoOhFourEight.Game.Grid

  describe "/new" do
    test "returns an empty 6x6 grid" do
      assert Grid.new == [
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0]
      ]
    end
  end
end
