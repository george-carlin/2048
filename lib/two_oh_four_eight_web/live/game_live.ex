defmodule TwoOhFourEightWeb.GameLive do
  use TwoOhFourEightWeb, :live_view

  @arrow_keys ~w[ArrowUp ArrowDown ArrowLeft ArrowRight]

  alias TwoOhFourEight.Game.Grid

  @impl true
  def mount(_params, _session, socket) do
    grid = Grid.new() |> Grid.add_random(2)
    {:ok, assign(socket, grid: grid)}
  end

  @impl true
  def handle_event("keydown", %{"key" => key}, socket) when key in @arrow_keys do
    direction = case key do
      "ArrowUp" -> :up
      "ArrowDown" -> :down
      "ArrowRight" -> :right
      "ArrowLeft" -> :left
    end

    grid = socket.assigns.grid
           |> Grid.shift(direction)
           |> Grid.add_random(1)

    {:noreply, assign(socket, grid: grid)}
  end

  @impl true
  def handle_event("keydown", %{"key" => _key}, socket), do: {:noreply, socket}
  # ^TODO how can I prevent the FE from sending irrelevant keys anyway? The
  # phx-key attr lets me limit it to 1 key but not >1
end
