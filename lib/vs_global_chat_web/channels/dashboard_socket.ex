defmodule VsGlobalChatWeb.DashboardSocket do
  # @behaviour Phoenix.Socket.Transport

  @max_rate 10
  @max_time_seconds 5

  @impl Phoenix.Socket.Transport
  def handle_in(tuple, {%{channels: channels, channels_inverse: inverse}, %Phoenix.Socket{} = socket} = state) do
    id = Map.keys(channels) |> List.to_string()

    message = tuple |> elem(0) |> Poison.decode!()

    message = %Phoenix.Socket.Message{
      ref: Enum.at(message, 0),
      join_ref: Enum.at(message, 1),
      topic: Enum.at(message, 2),
      event: Enum.at(message, 3),
      payload: Enum.at(message, 4)
    }

    # dbg socket.private.connect_info.peer_data.address

    should_rate_limit = case message.payload do
      %{"event" => "login"} -> true
      _ -> false
    end

    should_jail = if should_rate_limit do
      Cachex.fetch(VsGlobalChat.Cache.cache_name(), "rate_limit:" <> id, fn _ -> {:commit, 0, ttl: :timer.seconds(@max_time_seconds)} end)
      {:ok, current_rate} = Cachex.incr(VsGlobalChat.Cache.cache_name(), "rate_limit:" <> id, 1)
      if current_rate > @max_rate do
        ip = socket.private.connect_info.peer_data.address |> :inet_parse.ntoa()|> to_charlist()
        PhoenixDDoS.Jail.send(ip, Enum.at(Application.get_env(:phoenix_ddos, :_prots), 0))
        PhoenixDDoS.Jail.ips_in_jail()
        :jail_the_fucker
      else
        :pass
      end
    else
      :pass
    end

    if should_jail == :jail_the_fucker do
      {:stop, "Please stop being using this service so much.", state}
    else
      Phoenix.LiveView.Socket.handle_in(tuple, state)
    end
  end

  use Phoenix.LiveView.Socket

  def connect(_params, socket, connect_info) do
    if PhoenixDDoS.Jail.suspicious_ip?(connect_info.peer_data.address |> :inet_parse.ntoa() |> to_charlist()) do
      {:error, :rate_limit}
    else
      {:ok, socket}
    end
  end

  def handle_error(conn, :rate_limit) do
    Plug.Conn.send_resp(conn, 429, "")
  end
end
