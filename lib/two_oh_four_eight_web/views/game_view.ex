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
    val_class =
      case value do
        n when n < 0 -> "tile-inner-obstacle obstacle-#{abs(n)}"
        n when n > 2048 -> "tile-inner-super"
        n -> "tile-inner-#{n}"
      end
    "tile-inner #{val_class} #{if {x,y} == {newX,newY}, do: "tile-inner-newest"}"
  end
end
