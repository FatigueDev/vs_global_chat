defmodule VsGlobalChatWeb.Router do
  use VsGlobalChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug VsGlobalChatWeb.Plug.Authorization
    plug :fetch_live_flash
    plug :put_root_layout, html: {VsGlobalChatWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", VsGlobalChatWeb do
    pipe_through :browser

    live "/", MessageLive
  end
end
