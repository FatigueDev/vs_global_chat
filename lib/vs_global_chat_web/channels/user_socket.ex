defmodule VsGlobalChatWeb.UserSocket do
  use Phoenix.LiveView.Socket
  # alias Phoenix.Socket.Message

  channel "user_socket:*", VsGlobalChatWeb.UserChannel

  @impl true
  def connect(_params, socket, connect_info) do
    # send(socket_pid, {:socket_push, :send_sid, socket.id})
    # dbg params, structs: false
    # dbg socket, structs: false
    {:ok, assign(socket, :remote_ip, connect_info["remote_ip"])}
  end

  #   def handle_info(
  #       %Message{topic: topic, event: "phx_leave"} = message,
  #       %{topic: topic, serializer: serializer, transport_pid: transport_pid} = socket
  #     ) do
  #   send transport_pid, Poison.encode(message)
  #   {:stop, {:shutdown, :left}, socket}
  # end

  #   @impl true
  #   def handle_in(:send_sid, state) do
  #     dbg "HIT with " <> state
  #     {:ok, state}
  #   end

  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.remote_ip}"
end
