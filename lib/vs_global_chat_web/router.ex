defmodule VsGlobalChatWeb.Router do
  use VsGlobalChatWeb, :router
  import Phoenix.LiveView.Router

  # pipeline :auth do
  #   plug VsGlobalChatWeb.Plug.Authorization
  # end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VsGlobalChatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # scope "/api", VsGlobalChatWeb do
  #   pipe_through :api
  # end

  scope "/", VsGlobalChatWeb do
    pipe_through [:browser]


    # live_session :default, root_layout: {VsGlobalChatWeb.Layouts, :root} do
      live "/", IndexLive
      # get "/", SiteController, :index
      # get "/login", SiteController, :login
    # end
  end

end
