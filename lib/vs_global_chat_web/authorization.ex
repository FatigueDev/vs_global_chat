defmodule VsGlobalChatWeb.Plug.Authorization do
  @moduledoc """
  Reads a user_details cookie and puts user_details into session
  """
  require Logger
  import Plug.Conn
  import VsGlobalChat.LiveHelpers

  def init(_) do
    %{}
  end

  def call(conn, _opts) do

    remote_ip = get_remote_ip(conn)

    Logger.info("Connection received, attepting to get local_player for them with remote_ip: " <> remote_ip)

    local_player = get_player_by_remote_ip(remote_ip)

    if local_player != nil do
      Logger.info("Their local_player result was: " <> to_string(Poison.Encoder.Map.encode(local_player, %{})))
    else
      Logger.info("Their player result was nil.")
    end

    if authorized?(local_player) do

      Logger.info(remote_ip <> " was authorized")

      conn
      # Makes it available in LiveView
      |> put_session(:remote_ip, remote_ip)
      |> put_session(:authorized, true)
      |> put_session(:local_player, local_player)
      # Makes it available in traditional controllers etc
      |> assign(:remote_ip, remote_ip)
      |> assign(:authorized, true)
      |> assign(:local_player, local_player)

    else

      Logger.info(remote_ip <> " was NOT authorized")

      conn
        |> put_session(:remote_ip, nil)
        |> put_session(:authorized, nil)
        |> put_session(:local_player, nil)
        |> assign(:remote_ip, nil)
        |> assign(:authorized, nil)
        |> assign(:local_player, nil)

    end

  end

  @spec get_remote_ip(Plug.Conn.t()) :: binary()
  def get_remote_ip(conn) do
    forwarded_for = conn
      |> Plug.Conn.get_req_header("x-forwarded-for")
      |> List.first()

    if forwarded_for do
      forwarded_for
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> List.first()
    else
      conn.remote_ip
      |> :inet_parse.ntoa()
      |> to_string()
    end
  end
end
