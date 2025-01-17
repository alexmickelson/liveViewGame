defmodule LvGame.LobbyManager do
  use GenServer

  @pubsub_topic "lobby_updates"

  @impl true
  def init(_state) do
    IO.puts("started lobby manager")
    {:ok, []}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  # Client

  def get_list() do
    GenServer.call(__MODULE__, :get_games)
  end

  def add_game(game) do
    GenServer.cast(__MODULE__, {:add_game, game})
  end

  # Server
  @impl true
  def handle_call(:get_games, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:add_game, game}, state) do
    new_state = [game | state]
    Phoenix.PubSub.broadcast(LvGame.PubSub, @pubsub_topic, {:game_list, new_state})

    {:noreply, new_state}
  end
end
