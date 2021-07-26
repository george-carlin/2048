defmodule TwoOhFourEight.Game.Server do
  use GenServer

  @ets_key "two_oh_four_eight"
  @directions [:left, :right, :up, :down]

  alias TwoOhFourEight.Game.Game

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # API

  def new_game(opts \\ []) do
    GenServer.call(__MODULE__, {:new_game, opts})
  end

  def get_game do
    # For now there's only one active game but a future improvement could be to
    # have multiple simultaneous game rooms.
    GenServer.call(__MODULE__, :get_game)
  end

  def move(direction) when direction in @directions do
    GenServer.call(__MODULE__, {:move, direction})
  end

  # CALLBACKs

  def init(:ok) do
    game =
      case :ets.lookup(:current_game, @ets_key) do
        [{_name, existing_game}] -> existing_game
        [] -> Game.new()
      end
    {:ok, game}
  end

  def handle_call({:new_game, opts}, _from, _current_state) do
    num_obstacles = Keyword.get(opts, :num_obstacles, "0") |> String.to_integer()
    save_game_and_reply(Game.new(num_obstacles: num_obstacles))
  end

  def handle_call(:get_game, _from, current_game), do: save_game_and_reply(current_game)

  def handle_call({:move, direction}, _from, current_game) do
    save_game_and_reply(Game.move(current_game, direction))
  end

  defp save_game_and_reply(game) do
    :ets.insert(:current_game, {@ets_key, game})
    {:reply, game, game}
  end
end
