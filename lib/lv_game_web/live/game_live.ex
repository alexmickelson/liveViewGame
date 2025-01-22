defmodule LvGameWeb.GameLive do
  use LvGameWeb, :live_view

  def mount(_params, _session, socket) do
    # initialization here
    empty_set = MapSet.new()
    socket = assign(socket, :keys, empty_set)
    {:ok, socket}
  end

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
    # IO.puts(socket.assigns.keys)
    new_socket = update(socket, :keys, &MapSet.put(&1, key))
    {:noreply, new_socket}
  end

  def handle_event("keyup", %{"key" => key}, socket) when key in ~w(w a s d) do
    IO.puts("lifted key key pressed #{key}")
    new_socket = update(socket, :keys, &MapSet.delete(&1, key))
    {:noreply, new_socket}
  end

  def handle_event("keypress", _, socket) do
    IO.puts("unknown key pressed")
    {:noreply, socket}
  end

  def handle_event("keyup", _, socket) do
    IO.puts("unknown key lift")
    {:noreply, socket}
  end
end
