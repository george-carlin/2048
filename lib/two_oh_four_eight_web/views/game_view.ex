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

  def tile_inner_html_class(
    value,
    {x,y},
    %Game{newest_tile: {newX, newY}, obstacle_coords: obstacle_coords}
  ) do
    val_class =
      case value do
        -1 ->
          # Give the obstacle a unique identifier so we can style it uniquely
          obstacle_id = Enum.find_index(obstacle_coords, & &1 == {x,y}) + 1
          "tile-inner-obstacle obstacle-#{obstacle_id}"
        n when n > 2048 -> "tile-inner-super"
        n -> "tile-inner-#{n}"
      end
    "tile-inner #{val_class} #{if {x,y} == {newX,newY}, do: "tile-inner-newest"}"
  end
end
