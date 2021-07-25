defmodule TwoOhFourEight.Game.Grid do
  @size 6

  def new do
    for _ <- 1..@size do
      for _ <- 1..@size do
        0
      end
    end
  end
end
