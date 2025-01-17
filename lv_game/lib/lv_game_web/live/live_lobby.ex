defmodule LvGameWeb.LiveLobby do
  alias LvGame.LobbyManager
  alias Phoenix.PubSub
  use LvGameWeb, :live_view
  @pubsub_topic "lobby_updates"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      PubSub.subscribe(LvGame.PubSub, @pubsub_topic)
    end

    list = LobbyManager.get_list()
    {:ok, assign(socket, :game_list, list)}
  end

  def render(assigns) do
    ~H"""
    <h1>Game Lobbies</h1>
    <div>
      <form phx-submit="add_game">
        <label>
          New Game <input type="text" name="gameName" placeholder="Game name" />
        </label>
        <button type="submit">Add</button>
      </form>

      <h3>Games:</h3>
      <ul>
        <%= for game <- @game_list do %>
          <li>{game}</li>
        <% end %>
      </ul>
    </div>
    """
  end

  def handle_event("add_game", %{"gameName" => game_name}, socket) do
    IO.puts(game_name)
    LobbyManager.add_game(game_name)

    {:noreply, socket}
  end

  def handle_info({:game_list, new_list}, socket) do
    {:noreply, assign(socket, :game_list, new_list)}
  end
end
