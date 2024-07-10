defmodule VsGlobalChatWeb.RoomChannel do
  @moduledoc false

  alias VsGlobalChat.Player
  alias VsGlobalChat.Repo
  import Ecto.Query
  import Phoenix.HTML
  use VsGlobalChatWeb, :channel

  @impl true
  def join("room:lobby", payload, socket) do
    if player = get_player(payload) do
      if authorized?(player) do
        {:ok, socket}
      else
        {:error, %{reason: "You're banned from this service."}}
      end
    else
      create_player_result =
        case create_new_player(payload) do
          {:ok, player} ->
            {:ok, player}

          {:error, _} ->
            {:error, %{reason: "Player with UID already exists but they've changed their name."}}
        end

      player_authorized =
        case create_player_result do
          {:ok, player} -> authorized?(player)
          {:error, _} -> false
        end

      if player_authorized do
        {:ok, socket}
      else
        create_player_result
      end
    end
  end

  @impl true
  def handle_in("global_chat", payload, socket) do
    result = %{}
    result = Map.put(result, :sender, get_sender(payload) |> validate_sender())
    result = Map.put(result, :message, get_message(payload) |> validate_message())

    if not match?(:error, result.sender) and not match?(:error, result.message) do
      broadcast(socket, "global_chat", %{
        sender: elem(result.sender, 1),
        message: elem(result.message, 1)
      })

      {:noreply, socket}
    else
      bad_request(payload)
      {:reply, {:error, %{message: "Message failed to send due to a malformed payload."}}, socket}
    end
  end

  defp authorized?(%Player{} = player) do
    player.banned == false
  end

  defp get_player(payload) do
    {_, payload_uid} = escape_join_payload(payload)

    if player = Repo.one(from p in Player, where: p.uid == ^payload_uid, select: p) do
      player
    else
      nil
    end
  end

  defp create_new_player(payload) do
    {payload_name, payload_uid} = escape_join_payload(payload)

    changeset =
      Player.changeset(%Player{}, %{name: payload_name, uid: payload_uid})
      |> Ecto.Changeset.unique_constraint(:uid)

    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, result} -> {:ok, result}
        {:error, result} -> {:error, "You fucked up."}
      end
    else
      {:error, nil}
    end
  end

  defp escape_join_payload(payload) do
    {:safe, payload_name} = html_escape(payload["name"])
    {:safe, payload_uid} = html_escape(payload["uid"])
    {payload_name, payload_uid}
  end

  defp get_sender(payload) do
    case Map.fetch(payload, "sender") do
      {:ok, sender} -> {:ok, sender}
      :error -> :error
    end
  end

  defp get_message(payload) do
    case Map.fetch(payload, "message") do
      {:ok, message} -> {:ok, message}
      :error -> :error
    end
  end

  defp validate_sender(sender) do
    case sender do
      {:ok, sender} -> {:ok, sender}
      :error -> :error
    end
  end

  defp validate_message(message) do
    case message do
      {:ok, message} -> {:ok, message}
      :error -> :error
    end
  end

  defp bad_request(payload) do
    IO.warn("Bad request format for payload:\n" <> Jason.encode!(payload))
  end
end
