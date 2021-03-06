defmodule TwoOhFourEight.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TwoOhFourEightWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TwoOhFourEight.PubSub},
      # Start the Endpoint (http/https)
      TwoOhFourEightWeb.Endpoint,
      # Start a worker by calling: TwoOhFourEight.Worker.start_link(arg)
      # {TwoOhFourEight.Worker, arg}
      TwoOhFourEight.Game.Server
    ]

    :ets.new(:current_game, [:public, :named_table])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwoOhFourEight.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwoOhFourEightWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
