defmodule VsGlobalChatWeb.UserChannel do
  use VsGlobalChatWeb, :channel
  import VsGlobalChat.LiveHelpers
  import Phoenix.HTML
  alias VsGlobalChat.Message

  @impl true
  def join("user_socket:join", _payload, socket) do
    socket =
      assign(
        socket,
        ip:
          socket.private.connect_info.peer_data.address
          |> :inet_parse.ntoa()
          |> to_string()
      )

    Message.subscribe()

    {:ok, socket}
  end

  @impl true
  def handle_in("get_local_player", nil, socket) do
    player = Map.get(socket.assigns, :local_player)

    if player == nil do
      if socket.assigns.ip == nil do
        {:reply, {:error, %{message: "You have to join the channel first."}}, socket}
      else
        case get_player_by_remote_ip(socket.assigns.ip) do
          nil ->
            {:reply, {:error, %{message: "There was no player found for this address."}}, socket}

          player ->
            {:reply, {:ok, %{message: "Your local player has been assigned in the socket."}},
             assign(socket, local_player: player)}
        end
      end
    else
      {:reply, {:error, %{message: "You've already got your local player."}}, socket}
    end
  end

  def handle_in("get_local_authorization", nil, socket) do
    player = Map.get(socket.assigns, :local_player)

    if player == nil do
      {:reply, {:error, %{message: "You have to get_local_player before authorizing."}}, socket}
    else
      if is_player_authorized?(socket.assigns.local_player) do
        {:reply, {:ok, %{message: "You are now authorized to type in the chat."}},
         assign(socket, authorized: true)}
      else
        {:reply, {:error, %{message: "Player is not authorized to type in the chat."}}, socket}
      end
    end
  end

  def handle_in("new_player", %{"name" => name, "uid" => uid}, socket) do
    name = name |> html_escape() |> safe_to_string()
    uid = uid |> html_escape() |> safe_to_string()

    {code, result} = create_new_player(name, uid, socket.assigns.ip)

    if code == :error do
      {:reply,
       {:error, %{message: "Something went wrong creating your player.", ecto_result: result}},
       socket}
    else
      {:reply, {:ok, %{message: "Created a new player and set it in your socket assigns."}},
       assign(socket, local_player: result)}
    end
  end

  def handle_in("create_message", %{"message" => message}, socket) do
    can_post = Map.get(socket.assigns, :authorized, false)

    if can_post do
      message = message |> html_escape() |> safe_to_string()
      name = socket.assigns.local_player.name |> html_escape() |> safe_to_string()

      case Message.create_message(%{name: name, message: message}) do
        :ok -> {:noreply, socket}
        {:error, changeset} -> {:reply, {:error, %{message: errors_on(changeset)}}, socket}
      end
    else
      {:reply, {:error, %{message: "You are not authorized to create a message."}}, socket}
    end
  end

  def handle_in("receive_message", message, socket) do
    {:reply, {:ok, %{message: message}}, socket}
  end

  @impl true
  def handle_info({:message_created, %{name: name, message: message} = _new_message}, socket) do
    # send(transport_pid, %{event: "received_message", payload: , socket: socket})
    broadcast(socket, "receive_message", "#{name} says #{message}")
    {:noreply, socket}
  end

  # def handle_in("new_message_in_database", %{"message" => message}, socket) do
  #   {:reply, {:ok, %{message: "#{message.name} says #{message.message}"}}, socket}
  # end

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
