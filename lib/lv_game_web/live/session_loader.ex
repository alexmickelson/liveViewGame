defmodule LvGameWeb.SessionLoader do
  import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    # Fetch the username from the session or default to "Guest"
    username = Map.get(session, "username", "Guest")
    {:cont, assign(socket, :username, username)}
  end
end
