defmodule LvGame.GameRunner do
  use GenServer

  @pubsub_topic "game_updates"

  @impl true
  def init(_state) do
    IO.puts("started game runner")

    Process.send_after(self(), :tick, 100)

    {:ok,
     %{
       players: []
     }}
  end

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  # Client

  def add_player(name) do
    GenServer.cast(__MODULE__, {:add_player, name})
  end

  # Server

  @impl true
  def handle_cast({:add_player, name}, state) do
    players = Map.get(state, :players, [])

    # Check if a player with the same name already exists
    if Enum.any?(players, fn %{name: n} -> n == name end) do
      {:noreply, state}
    else
      new_player = %{X: 0, Y: 0, name: name}
      new_state =
        state
        |> Map.update(:players, [new_player], &[new_player | &1])
      # IO.inspect(new_state)
      {:noreply, new_state}
    end
  end

  @impl true
  def handle_info(:tick, state) do
    updated_players =
      state.players
      |> Enum.map(fn player -> %{player | X: player."X"} end)

      new_state =
      state
      |> Map.update(:players, [], fn _old -> updated_players end)

    Phoenix.PubSub.broadcast(LvGame.PubSub, @pubsub_topic, {:game_state, new_state})

    Process.send_after(self(), :tick, 100)
    {:noreply, new_state}
  end
end
