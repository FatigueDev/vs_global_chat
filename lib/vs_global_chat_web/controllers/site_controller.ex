defmodule VsGlobalChatWeb.SiteController do

  # alias VsGlobalChatWeb.{IndexLive, LoginLive}
  # import Phoenix.Controller
  # import Phoenix.LiveView
  # import Phoenix.LiveView.Controller

  # def init(atom) do
  #   atom
  # end

  # def call(conn, path) do
  #   dbg path
  #   dbg conn.assigns
  #   case path do
  #     :index -> index(conn, nil)
  #     :login -> login(conn, nil)
  #     _ -> nil
  #   end
  # end

  # def index(conn, _) do
  #   live_render(conn, VsGlobalChatWeb.IndexLive, session: %{}, sticky: true)
  # end


  # def login(conn, _) do
  #   conn = conn |> live_render(VsGlobalChatWeb.LoginLive, session: %{}, sticky: true)
  # end

  # import Phoenix.Component, only: [assign: 2, assign: 3, assign_new: 3]

  # def on_mount(:default, _params, %{"authenticated" => true} = _session, socket) do
  #   dbg "AuthController: Authenticated is true."
  #   socket =
  #     socket
  #     |> assign_new(:authenticated, fn -> true end)

  #   {:cont, socket}
  # end

  # def on_mount(:require_authenticated_user, _, session, socket) do
  #   dbg socket
  #   dbg session
  #   socket = verify_authenticated(socket, session)
  #   case socket.assigns.authenticated do
  #     nil ->
  #       socket = socket |> Phoenix.LiveView.put_flash(:error, "You must be signed in.")
  #       socket = socket |> Phoenix.LiveView.push_navigate(to: "/login")
  #       {:halt, socket}

  #     true ->
  #       {:cont, socket}

  #   end
  # end

  # defp verify_authenticated(socket, session) do
  #   case session do
  #     %{"authenticated" => true} ->
  #       assign_new(socket, :authenticated, fn ->
  #         true
  #       end)

  #     %{} ->
  #       assign_new(socket, :authenticated, fn -> nil end)

  #   end
  # end

  # def authenticate(conn, _params) do
  #   conn
  #   |> put_session(:authenticated, true)
  #   |> redirect(to: "/")
  # end

  # def init(var) do
  #   dbg var
  # end

  # def call(conn, params) do
  #   dbg "Hit call."
  #   conn
  # end

  # def index(conn, params) do
  #   login(conn, params)
  # end

  # def show(conn, params) do
  #   conn
  # end

  # def login(conn, params) do
  #   dbg "Hit login."

  # end

  # def index(conn, params) do
  #   # conn = conn |> put_layout(VsGlobalChatWeb.Layouts)
  #   verify_authentication(conn, nil)
  # end

  # defp verify_authentication(conn, _options) do
  #   dbg "Hit auth; session :authenticated value is #{get_session(conn, :authenticated, false)}"
  #   if get_session(conn, :authenticated, false) == true do
  #     dbg "Trying to live render IndexLive"
  #     live_render(conn, VsGlobalChatWeb.IndexLive)
  #   else
  #     dbg "Trying to live render LoginLive"
  #     # conn |> redirect(to: "/login", session: %{}) |> halt()
  #     live_render(conn, VsGlobalChatWeb.LoginLive)
  #   end
  # end

  # def call(conn, params) do

  #   dbg conn
  #   dbg params

  #   dbg "Hello World"
  #   conn
  # end

  # def auth_test(conn, _params) do

  #   dbg conn

  #   conn
  # end
end
