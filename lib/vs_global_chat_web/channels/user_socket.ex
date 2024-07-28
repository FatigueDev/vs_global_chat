defmodule VsGlobalChatWeb.UserSocket do
  require Logger
  alias Protobuf
  alias Phoenix.PubSub
  alias VsGlobalChat.{User, Message}

  @behaviour Phoenix.Socket.Transport

  @resolve_client_session_url "https://auth2.vintagestory.at/clientvalidate"
  @resolve_player_uid_url "https://auth2.vintagestory.at/resolveplayeruid"

  def child_spec(_opts) do
    # We won't spawn any process, so let's ignore the child spec
    :ignore
  end

  def connect(state) do
    # Callback to retrieve relevant data from the connection.
    # The map contains options, params, transport and endpoint keys.
    case state.params do
      %{"uid" => uid, "sessionkey" => session_key, "auth_token" => auth_token, "module" => module} ->
        validate_userdata_and_login(
          URI.decode(uid),
          URI.decode(session_key),
          URI.decode(auth_token),
          Map.put(state, :module, URI.decode(module))
        )
        |> post_connect()

      _ ->
        {:error, "Not authorized."}
    end
  end

  def validate_userdata_and_login(uid, session_key, auth_token, state) do
    session_response =
      HTTPoison.post!(
        @resolve_client_session_url,
        {:form, [{"uid", uid}, {"sessionkey", session_key}]}
      )

    if Poison.decode!(session_response.body)["valid"] != 1 do
      {:error, "Nah, mate."}
    else
      try_login(uid, auth_token, state)
    end
  end

  def try_login(uid, auth_token, state) do
    player_name_response = HTTPoison.post!(@resolve_player_uid_url, {:form, [{"uid", uid}]})
    player_name = Poison.decode!(player_name_response.body)["playername"]

    case User.get_user_by_uid(uid) do
      %User{} = repo_user ->
        unless player_name == repo_user.name do
          Logger.info(%{event: :player_name_updated, from: repo_user.name, to: player_name})
          User.update_user(repo_user, %{name: player_name})
        end

        if not repo_user.banned and user_matches_params?(repo_user, uid, auth_token) do
          Logger.info(%{event: :player_logged_in, user: repo_user})
          {:ok, Map.put(state, :user, repo_user)}
        else
          Logger.warning(%{
            message: "Unauthorized user tried to login with credentials",
            user: repo_user
          })

          {:error, "Not authorized"}
        end

      _ ->
        {:ok, new_user} =
          User.create_user(%User{
            auth_token: auth_token,
            uid: uid,
            permissions: :user,
            name: player_name
          })

        {:ok, Map.put(state, :user, new_user)}
    end
  end

  def post_connect({:ok, state}) do
    PubSub.subscribe(VsGlobalChat.PubSub, state.module)
    dbg("Subscribing to " <> state.module)
    {:ok, state}
  end

  def post_connect({:error, message}), do: {:error, message}

  def user_matches_params?(%User{} = user, uid, auth_token) do
    if user.uid == uid and user.auth_token == auth_token do
      true
    else
      false
    end
  end

  def init(state) do
    # Now we are effectively inside the process that maintains the socket.
    {:ok, state}
  end

  def handle_in({payload, _opcode}, state) do
    try do
      Protobuf.decode(payload, VsGlobalChatProto.Payload) |> handle_payload(state)
    rescue
      Protobuf.DecodeError ->
        Logger.error(%{message: "Failed to decode payload for state:", state: state})
        {:error, "Failed to decode payload"}
    end
  end

  def handle_payload(%VsGlobalChatProto.Payload{Event: "broadcast"} = payload, state) do
    dbg("Broadcasting!")

    Phoenix.PubSub.broadcast(
      VsGlobalChat.PubSub,
      Map.get(payload, :Module),
      {:broadcast, payload}
    )

    {:ok, state}
  end

  # def handle_payload(%VsGlobalChatProto.Payload{} = payload, state) do
  #   # dbg("Handling processed")
  #   {:reply, :ok, {:binary, Protobuf.encode(payload)}, state}
  # end

  def handle_info({:broadcast, %VsGlobalChatProto.Payload{} = payload}, state) do
    # dbg("Trying to set payload to processed")
    # payload = Map.put(payload, :Processed, true)
    # Phoenix.PubSub.broadcast(VsGlobalChat.PubSub, Map.get(payload, :Module), payload)
    # send(self(), {payload, :broadcast})
    {:push, {:binary, Protobuf.encode(payload)}, state}
  end

  # def handle_in({message, opcode}, state) do
  #   dbg "Message didn't match any existing patterns."
  #   {:ok, state}
  # end

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

  # def handle_info({"messages_repo_changed", %VsGlobalChat.Message{} = message}, state) do
  #   {:push, {:text, Poison.encode!(raw_to_pretty_message(message.user.name, message.text))}, state}
  # end

  # def raw_to_pretty_message(name, text) do
  #   "VSGC: #{name} says \"#{text}\""
  # end

  def terminate(_reason, _state) do
    :ok
  end
end
