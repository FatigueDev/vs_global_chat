defmodule VsGlobalChatWeb.IndexLive do
  use VsGlobalChatWeb, :live_surface_view

  alias Surface.Components.Context
  alias VsGlobalChat.{User, Message}

  def render(assigns) do
    ~F"""
    <div>
      {#if Map.get(assigns, :authorized, false) == true}
        <VsGlobalChatWeb.Components.Dashboard id="dashboard"/>
      {#else}
        <VsGlobalChatWeb.Components.Login id="login"/>
      {/if}
    </div>
    """
  end

  def mount(_params, _session, socket) do

    socket =
      socket
      |> assign(
        :ip,
        Phoenix.LiveView.get_connect_info(socket, :peer_data).address
          |> :inet_parse.ntoa()
          |> to_string()
      )

    case authenticated?(socket.assigns.ip) do
      true ->
        {:ok, subscribe_and_assign(socket)}
      false ->
        {:ok, set_unauthorized_assigns(socket)}
    end
  end

  def authenticated?(ip_address) when is_bitstring(ip_address) do
    {:ok, is_authed} = VsGlobalChat.Cache.get(VsGlobalChat.Cache.to_auth_key(ip_address))
    is_authed == true
  end
  def authenticated?(_), do: false

  def set_unauthorized_assigns(socket) do
    socket
      |> assign(authorized: false)
      |> Context.put(authorized: false)
      |> Context.put(show_user_modal: false)
      |> Context.put(modal_user: nil)
      |> Context.put(users: [])
      |> Context.put(messages: [])
  end

  def subscribe_and_assign(socket) do

    User.subscribe()
    Message.subscribe()

    socket
      |> assign(authorized: true)
      |> Context.put(show_user_modal: false)
      |> Context.put(modal_user: nil)
      |> Context.put(users: User.list_users())
      |> Context.put(messages: Message.list_messages())
  end

  def handle_info({"users_repo_changed", :changed}, socket) do
    new_users = User.list_users()

    modal_user = Context.get(socket, :modal_user)

    new_modal_user = Enum.find(new_users, fn u -> u.id == modal_user.id end)

    socket =
      socket
      |> Context.put(modal_user: new_modal_user)
      |> Context.put(users: User.list_users())

    {:noreply, socket}
  end

  def handle_info({"messages_repo_changed", _message}, socket) do
    {:noreply, Context.put(socket, messages: Message.list_messages())}
  end

  def handle_event("clear_flash", _params, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_event("user_row_clicked", %{"item" => item} = _params, socket) do

    repo_user = User.get_user!(item)

    socket =
      socket
      |> Context.put(modal_user: repo_user)
      |> Context.put(show_user_modal: true)

    {:noreply, socket}
  end

  def handle_event("message_row_clicked", %{"item" => item} = _params, socket) do

    repo_user = Message.get_user_from_message_id(item)

    socket =
      socket
      |> Context.put(modal_user: repo_user)
      |> Context.put(show_user_modal: true)

    {:noreply, socket}
  end

  def handle_event("modal_close", _, socket) do
    socket =
      socket
      |> Context.put(modal_user: nil)
      |> Context.put(show_user_modal: false)

    {:noreply, socket}
  end

  def handle_event("login", %{"login_form" => %{"username" => username, "password" => password}} = _value, socket) do
    case VsGlobalChat.Helpers.Authentication.try_login(username, password) do
      true ->

        User.subscribe()
        Message.subscribe()

        VsGlobalChat.Cache.put_auth(socket.assigns.ip)

        socket = socket |> subscribe_and_assign()
        {:noreply, socket}
      false ->
        {:noreply, assign(socket, authorized: false)}
    end
  end

end
