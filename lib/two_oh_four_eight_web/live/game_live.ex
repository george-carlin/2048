defmodule TwoOhFourEightWeb.GameLive do
  use TwoOhFourEightWeb, :live_view

  @arrow_keys ~w[ArrowUp ArrowDown ArrowLeft ArrowRight]

  @topic "game"

  alias TwoOhFourEight.Game.Game
  alias TwoOhFourEight.Game.Server

  @impl true
  def render(assigns) do
    TwoOhFourEightWeb.GameView.render("live.html", assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(TwoOhFourEight.PubSub, @topic)

    {:ok, assign(socket, game: Server.get_game())}
  end

  @impl true
  def handle_event("new_game", %{"num_obstacles" => num_obstacles}, socket) do
    Server.new_game(num_obstacles: num_obstacles)
    broadcast_refresh!()
    {:noreply, assign(socket, game: Game.new())}
  end

  @impl true
  def handle_event("keydown", %{"key" => key}, socket) when key in @arrow_keys do
    direction = case key do
      "ArrowUp" -> :up
      "ArrowDown" -> :down
      "ArrowRight" -> :right
      "ArrowLeft" -> :left
    end

    game = Server.move(direction)

    broadcast_refresh!()

    {:noreply, assign(socket, game: game)}
  end

  @impl true
  def handle_event("keydown", %{"key" => _key}, socket), do: {:noreply, socket}
  # ^TODO how can I prevent the FE from sending irrelevant keys anyway? The
  # phx-key attr lets me limit it to 1 key but not >1

  @impl true
  def handle_info(:refresh, socket) do
    {:noreply, assign(socket, game: Server.get_game())}
  end

  defp broadcast_refresh! do
    Phoenix.PubSub.broadcast(TwoOhFourEight.PubSub, @topic, :refresh)
  end
end
