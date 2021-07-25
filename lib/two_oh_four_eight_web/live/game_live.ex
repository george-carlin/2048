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

  #@impl true
  #def handle_event("search", %{"q" => query}, socket) do
  #  case search(query) do
  #    %{^query => vsn} ->
  #      {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

  #    _ ->
  #      {:noreply,
  #       socket
  #       |> put_flash(:error, "No dependencies found matching \"#{query}\"")
  #       |> assign(results: %{}, query: query)}
  #  end
  #end

  #defp search(query) do
  #  if not TwoOhFourEightWeb.Endpoint.config(:code_reloader) do
  #    raise "action disabled when not in development"
  #  end

  #  for {app, desc, vsn} <- Application.started_applications(),
  #      app = to_string(app),
  #      String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
  #      into: %{},
  #      do: {app, vsn}
  #end
end
