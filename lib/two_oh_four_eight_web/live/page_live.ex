defmodule TwoOhFourEightWeb.PageLive do
  use TwoOhFourEightWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    grid = [    
      [1,2,4,8,16,32],
      [64,128,256,512,1024,2048],
      [4096,8192,0,0,0,0],
      [0,0,0,0,0,0],
      [0,0,0,0,0,0],
      [0,0,0,0,0,0]
    ]
    {:ok, assign(socket, grid: grid)}
  end

  #@impl true
  #def handle_event("suggest", %{"q" => query}, socket) do
  #  {:noreply, assign(socket, results: search(query), query: query)}
  #end

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
