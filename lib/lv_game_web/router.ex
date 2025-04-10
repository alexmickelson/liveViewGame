defmodule LvGameWeb.Router do
  use LvGameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LvGameWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LvGameWeb do
    pipe_through :browser

    live "/light", LightLive
    live "/lobby", LiveLobby
    live "/game", GameLive
    live_session :default, on_mount: [LvGameWeb.SessionLoader] do
      live "/login", SetUserLive
      live "/", GameLive
    end
    # get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", LvGameWeb do
  #   pipe_through :api

  #   # https://thepugautomatic.com/2020/05/persistent-session-data-in-phoenix-liveview/
  #   post "/session", SessionController, :set
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:lv_game, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LvGameWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
