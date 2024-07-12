defmodule VsGlobalChatWeb.UserChannel do
  use VsGlobalChatWeb, :channel
  alias VsGlobalChat.Player
  import VsGlobalChat.LiveHelpers

  @impl true
  def handle_call("user_socket:get_local_player", nil, socket) do
    player = get_player_by_remote_ip(socket.private.connect_info.session["remote_ip"])
    {:ok, {:reply, local_player: player}, socket}
  end

  def handle_call("user_socket:get_local_authorization", nil, socket) do
    if authorized = is_player_authorized?(socket.assigns["local_player"]) do
      {:ok, {:reply, authorized: authorized}, socket}
    else
      {:error, {:reply, message: "Player is not authorized"}, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # @impl true
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # # It is also common to receive messages from the client and
  # # broadcast to everyone in the current topic (user:lobby).
  # @impl true
  # def handle_in("shout", payload, socket) do
  #   broadcast(socket, "shout", payload)
  #   {:noreply, socket}
  # end

  # # Add authorization logic here as required.
  # defp authorized?() do
  #   true
  # end
end
