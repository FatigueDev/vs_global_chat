defmodule VsGlobalChatWeb.MessageLive do
  use VsGlobalChatWeb, :live_view
  import VsGlobalChat.LiveHelpers
  alias VsGlobalChat.Message
  alias VsGlobalChat.Presence
  alias VsGlobalChat.PubSub

  @presence_topic "liveview_chat_presence"

  def mount(_params, session, socket) do

    if connected?(socket) and is_session_authorized?(session) do

      Message.subscribe()

      {:ok, _} = Presence.track(self(), @presence_topic, session["local_player"].uid, %{name: session["local_player"].name})
      Phoenix.PubSub.subscribe(PubSub, @presence_topic)

    end

    changeset =
      if session["local_player"] != nil do
        dbg "Should have set name to " <> session["local_player"].name
        Message.changeset(%Message{}, %{"name" => session["local_player"].name})
      else
        Message.changeset(%Message{}, %{})
      end

    messages = Message.list_messages() |> Enum.reverse()

    {:ok,
    assign(socket,
      messages: messages,
      changeset: changeset,
      authorized: is_session_authorized?(session),
      local_player: if(session["local_player"] != nil, do: session["local_player"], else: nil),
      presence: get_presence_names()
    ), temporary_assigns: [messages: []]}
  end

  def is_session_authorized?(session) do
    if Map.has_key?(session, "authorized") and Map.has_key?(session, "local_player") do

      player = session["local_player"]

      if is_nil(player) do
        false
      else
        player.banned == false
      end

    else
      false
    end
  end

  # def try_get_local_player(socket) do
  #   case VsGlobalChatWeb.UserChannel.handle_call("user_socket:get_local_player", nil, socket) do
  #     {:ok, {:reply, local_player: local_player}, socket} -> local_player;
  #     {:error, message} -> dbg {:error, message}; nil
  #   end
  # end

  # def try_authorize_local_player(socket) do
  #   case VsGlobalChatWeb.UserChannel.handle_call("user_socket:get_local_authorization", nil, socket) do
  #     {:ok, {:reply, authorized: authorized}, socket} -> authorized
  #     {:error, {:reply, message: message}, socket} -> dbg message; false;
  #   end
  # end

  def render(assigns) do
    VsGlobalChatWeb.MessageView.render("messages.html", assigns)
  end

  def handle_event("new_message", %{"message" => params}, socket) do
    dbg socket, structs: false

    params = Map.put(params, "name", socket.assigns.local_player.name)
    case Message.create_message(params) do
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}

      :ok ->
        changeset = Message.changeset(%Message{}, %{"name" => params["name"]})
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info({:message_created, message}, socket) do
    {:noreply, assign(socket, messages: [message])}
  end

  def handle_info(%{event: "presence_diff", payload: _diff}, socket) do
    {
      :noreply,
      assign(socket, presence: get_presence_names())
    }
  end

  defp get_presence_names() do
    Presence.list(@presence_topic)
    |> Enum.map(fn {_k, v} -> List.first(v.metas).name end)
  end
end
