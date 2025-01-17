defmodule LvGameWeb.GameLive do
  use LvGameWeb, :live_view

  def mount(_params, _session, socket) do
    # initialization here
    {:ok, socket}
  end


  def render(assigns) do
    ~H"""
    <h1>Game</h1>
    """
  end
end
