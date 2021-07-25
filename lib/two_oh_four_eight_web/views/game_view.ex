defmodule TwoOhFourEightWeb.GameView do
  use TwoOhFourEightWeb, :view

  alias TwoOhFourEight.Game.Game

  def status(game) do
    case game.status do
      :game_over -> "Game over!"
      :won -> "You win!"
      _ -> ""
    end
  end

  def tile_inner_html_class(value, {x,y}, %Game{newest_tile: {newX, newY}}) do
    val_class = if value <= 2048, do: value, else: "super"
    "tile-inner tile-inner-#{val_class} #{if {x,y} == {newX,newY}, do: "tile-inner-newest"}"
  end
end
