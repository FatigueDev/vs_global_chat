defmodule VsGlobalChatWeb.UserSocket do
  require Logger
  alias Protobuf
  alias VsGlobalChat.{User, Message}

  @behaviour Phoenix.Socket.Transport

  @resolve_playername_url "https://auth2.vintagestory.at/resolveplayername"
  @resolve_playeruid_url "https://auth2.vintagestory.at/resolveplayeruid"

  def child_spec(_opts) do
    # We won't spawn any process, so let's ignore the child spec
    :ignore
  end

  def connect(state) do
    # Callback to retrieve relevant data from the connection.
    # The map contains options, params, transport and endpoint keys.
    case state.params do
      %{"name" => name, "uid" => uid, "auth_token" => auth_token} ->
        validate_userdata_and_login(name, uid, auth_token, state)
      _ ->
        {:error, "Not authorized."}
    end
  end

  def validate_userdata_and_login(name, uid, auth_token, state) do
    resolved_player_name = HTTPoison.post!(@resolve_playername_url, {:form, [{"playername", name}]})
    resolved_player_uid = HTTPoison.post!(@resolve_playeruid_url, {:form, [{"uid", uid}]})

    if Poison.decode!(resolved_player_name.body)["playeruid"] != uid or Poison.decode!(resolved_player_uid.body)["playername"] != name do
      {:error, "Nah, mate."}
    else
      try_login(name, uid, auth_token, state)
    end

  end

  def try_login(name, uid, auth_token, state) do
    case User.get_user_by_uid(uid) do
      %User{} = repo_user ->
        if not repo_user.banned and user_matches_params?(repo_user, name, uid, auth_token) do
          Message.subscribe()
          {:ok, Map.put(state, :user, repo_user)}
        else
          Logger.warning({"Unauthorized user tried to login with credentials", name, uid, auth_token})
          {:error, "Not authorized"}
        end
      _ ->
        {:ok, new_user} = User.create_user(%User{auth_token: auth_token, uid: uid, permissions: :user, name: name})
        {:ok, Map.put(state, :user, new_user)}
    end
  end

  def user_matches_params?(%User{} = user, name, uid, auth_token) do
    if user.name == name and user.uid == uid and user.auth_token == auth_token do
      true
    else
      false
    end
  end

  def init(state) do
    # Now we are effectively inside the process that maintains the socket.
    {:ok, state}
  end

  def handle_in({message, _opcode}, state) do

    {:safe, message} =
      message
      |> PhoenixHtmlSanitizer.Helpers.sanitize(:strip_tags)

    Message.create(state.user, message)

    # case Poison.decode!(message) do
    #   %{"message" => text} ->
    #     Message.create(state.user, text)
    {:ok, state}
    #   _ -> {:error, "Bad request"}
    # end

  end

  # def handle_in({message, _opts}, state) do

  #   dbg message

  #   case Poison.decode!(message) do
  #     %{"message" => text} ->
  #       Message.create(state.user, text)
  #       {:ok, state}
  #     _ -> {:error, "Bad request"}
  #   end

  # end

  # def handle_call({:new_message, message}, _from, state) do
  #   dbg "Hit handle_in with"
  #   dbg message
  #   # {:ok, state}
  #   {:reply, :ok, {:text, "Someone says #{message.text}"}, state}
  # end

  def handle_info({"messages_repo_changed", %VsGlobalChat.Message{} = message}, state) do
    {:push, {:text, Poison.encode!(raw_to_pretty_message(message.user.name, message.text))}, state}
  end

  def raw_to_pretty_message(name, text) do
    "VSGC: #{name} says \"#{text}\""
  end

  def terminate(_reason, _state) do
    :ok
  end

end
