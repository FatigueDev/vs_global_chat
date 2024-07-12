defmodule VsGlobalChatWeb.Plug.Authorization do
  @moduledoc """
  Reads a user_details cookie and puts user_details into session
  """
  require Logger
  alias VsGlobalChatWeb.MessageLive
  alias VsGlobalChatWeb.NotAuthorized
  import Plug.Conn
  import VsGlobalChat.LiveHelpers

  def init(_) do
    %{}
  end

  def call(conn, _opts) do
    remote_ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join(".")


    Logger.info("Connection received, their conn is: " <> to_string(Poison.Encoder.Map.encode(conn, %{})))
    # Logger.info("Connection received, attepting to get local_player for them with remote_ip: " <> remote_ip)

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
end
