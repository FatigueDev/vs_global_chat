defmodule VsGlobalChatWeb.Authorization do
  use VsGlobalChatWeb, :controller
  import Phoenix.Component, only: [assign_new: 3]

  # def on_mount(:default, _params, %{"jwt" => jwt} = _session, socket) do
  #   socket =
  #     socket
  #     |> assign_new(:person, fn ->
  #       jwt
  #       |> AuthPlug.Token.verify_jwt!()
  #       |> AuthPlug.Helpers.strip_struct_metadata()
  #       |> Useful.atomize_map_keys()
  #     end)
  #     |> assign_new(:loggedin, fn -> true end)

  #   {:cont, socket}
  # end

  # def call(conn, _opts) do
  #   conn
  #   |> put_status(302)
  # end

  # def on_mount(:default, _params, _session, socket) do
  #   socket = assign_new(socket, :loggedin, fn -> false end)
  #   {:cont, socket}
  # end

  # def login(conn, _params) do
  #   redirect(conn, external: "https://google.com")
  # end

  # def logout(conn, _params) do
  #   conn
  #   |> put_status(302)
  #   |> redirect(to: "/")
  # end
end
