defmodule LvGame.LobbyManager do
  use GenServer

  @impl true
  def init(state) do
    IO.puts("started lobby manager")
    {:ok, state}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end
end
