defmodule VsGlobalChatWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :vs_global_chat

  plug RemoteIp, headers: ["x-forwarded-for"]
  plug PhoenixDDoS

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_vs_global_chat_key",
    signing_salt: "nsBVx2fc",
    same_site: "Lax"
  ]

  socket "/live", VsGlobalChatWeb.DashboardSocket,
    websocket: [connect_info: [:peer_data, :x_headers], error_handler: {VsGlobalChatWeb.DashboardSocket, :handle_error, []}],
    longpoll: [connect_info: [:peer_data, :x_headers], error_handler: {VsGlobalChatWeb.DashboardSocket, :handle_error, []}]

  socket "/socket", VsGlobalChatWeb.UserSocket,
    websocket: [connect_info: [:peer_data, :x_headers]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :vs_global_chat,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :vs_global_chat
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug VsGlobalChatWeb.Router
end
