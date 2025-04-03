defmodule LvGameWeb.SetUserLive do
  use LvGameWeb, :live_view

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(socket, username: "")
      |> assign(:error, nil)
    }
  end

  def render(assigns) do
    ~H"""
    <div class="w-full max-w-sm p-6 bg-emerald-900 shadow-lg rounded-lg">
      <%= if @error do %>
        <div class="mb-4 p-3 text-sm text-red-700 bg-red-100 border border-red-300 rounded">
          {@error}
        </div>
      <% end %>

      <form phx-submit="set_username" class="space-y-4">
        <div>
          <label class="block text-emerald-50 text-sm font-bold mb-2">Enter your username:</label>
          <input
            type="text"
            name="username"
            class="
              w-full p-2 bg-emerald-950
              border border-emerald-300 rounded
              focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent
            "
          />
        </div>

        <div>
          <button
            type="submit"
            class="w-full bg-emerald-950 text-white py-2 rounded hover:bg-emerald-600 transition duration-150"
          >
            Submit
          </button>
        </div>
      </form>
    </div>
    """
  end

  def handle_event("set_username", %{"username" => username}, socket) when username != "" do
    IO.puts(username)
    socket =
      socket
      |> assign(:username, username)
      # |> put_session(:username, username)
      |> push_navigate(to: "/")

    {:noreply, socket}
  end

  def handle_event("set_username", %{"username" => _username}, socket) do
    {:noreply, assign(socket, error: "Username cannot be blank")}
  end
end
