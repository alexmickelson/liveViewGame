defmodule LvGameWeb.GameLive do
  use LvGameWeb, :live_view
  alias LvGame.GameRunner
  alias Phoenix.PubSub
  @pubsub_topic "game_updates"

  @impl true
  def mount(_params, _session, socket = %{:username => username}) do
    if connected?(socket) do
      PubSub.subscribe(LvGame.PubSub, @pubsub_topic)
    end

    GameRunner.add_player("alex")

    empty_set = MapSet.new()
    socket = assign(socket, :keys, empty_set)
    socket = assign(socket, :username, username)
    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    IO.puts("got empty socket")
    IO.inspect(socket.assigns)
    get_in(socket.assigns, [:username]) || "Guest" |> IO.inspect()
    Map.get(socket, :username) |> IO.inspect()

    {:ok, redirect(socket, to: "/login")}
  end

  # def render(%{game: _} = assigns) do
  #   IO.puts("render with game")

  #   ~H"""
  #   <div phx-window-keydown="keypress" phx-window-keyup="keyup" class="bg-stone-950">
  #     keys pressed:
  #     <%= for key <- @keys do %>
  #       <div>{key}</div>
  #     <% end %>
  #     <div>
  #       <%= for player <- @game.players do %>
  #         <div>{player.name}</div>
  #       <% end %>
  #     </div>
  #   </div>
  #   """
  # end

  def render(assigns) do
    ~H"""
    <h1>Game</h1>
    <div phx-window-keydown="keypress" phx-window-keyup="keyup">
      keys pressed:
      <%= for key <- @keys do %>
        <div>{key}</div>
      <% end %>
    </div>
    """
  end

  def handle_event("keypress", %{"key" => key}, socket) when key in ~w(w a s d) do
    IO.puts("pressed #{key}")
    new_socket = update(socket, :keys, &MapSet.put(&1, key))
    {:noreply, new_socket}
  end

  def handle_event("keyup", %{"key" => key}, socket) when key in ~w(w a s d) do
    IO.puts("lifted key #{key}")
    new_socket = update(socket, :keys, &MapSet.delete(&1, key))
    {:noreply, new_socket}
  end

  def handle_event("keypress", _, socket) do
    {:noreply, socket}
  end

  def handle_event("keyup", _, socket) do
    {:noreply, socket}
  end

  def handle_info({:game_state, new_game_state}, socket) do
    IO.inspect(new_game_state)
    # {:noreply, socket}
    {:noreply, assign(socket, :game, new_game_state)}
  end
end
