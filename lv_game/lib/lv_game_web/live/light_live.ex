defmodule LvGameWeb.LightLive do
  use LvGameWeb, :live_view
  # use Phoenix.LiveView # alternative, seems to not inherit layout from the LvGameWeb module

  # params is a map containing the current query params, as well as any router parameters
  # session is a map containing private session data
  # socket is a struct where the state of the LiveView process is stored
  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>
    </div>
    <button phx-click="down">
    Down
    </button>
    <button phx-click="up">
    Up
    </button>
    """
  end

  def handle_event("down", _, socket) do
    {:noreply, update(socket, :brightness, fn b -> b - 10 end)}
  end

  def handle_event("up", _, socket) do
    {:noreply, update(socket, :brightness, &(&1 + 10))}
  end
end
