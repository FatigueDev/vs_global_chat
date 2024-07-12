defmodule VsGlobalChat.LiveHelpers do
  alias VsGlobalChat.Player
  alias VsGlobalChat.Repo
  import Ecto.Query

  def is_player_authorized?(%Player{} = player) do
    if authorized?(player) do
      true
    else
      false
    end
  end

  def is_player_authorized?(_) do
    false
  end

  def authorized?(%Player{} = player) do
    player.banned == false
  end

  def authorized?(_) do
    false
  end

  def get_player_by_remote_ip(ip) when is_binary(ip) do
    if player = Repo.one(from p in Player, where: p.ip == ^ip, select: p) do
      player
    else
      nil
    end
  end

  def get_player_by_remote_ip(_), do: nil

  def create_new_player(name, uid, ip) do
    changeset =
      Player.changeset(%Player{}, %{name: name, uid: uid, ip: ip})
      |> Ecto.Changeset.unique_constraint(:uid)
      |> Ecto.Changeset.unique_constraint(:ip)

    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, result} -> {:ok, result}
        {:error, changeset} -> {:error, errors_on(changeset)}
      end
    else
      {:error, nil}
    end
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
