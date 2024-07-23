defmodule VsGlobalChat.User do
  @moduledoc false

  require Logger

  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias Phoenix.PubSub
  alias VsGlobalChat.Repo

  schema "users" do
    field :name, :string
    field :permissions, Ecto.Enum, values: [:user, :moderator, :administrator, :system], default: :user
    field :uid, :string
    field :banned, :boolean, default: false
    field :auth_token, :string, redact: true
    has_many :messages, VsGlobalChat.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :uid, :banned, :auth_token, :permissions])
    |> cast_assoc(:messages)
    |> validate_required([:name, :uid, :auth_token, :permissions])
    |> unique_constraint(:auth_token)
    |> unique_constraint(:uid)
  end

  @doc false
  def subscribe() do
    PubSub.subscribe(VsGlobalChat.PubSub, get_topic_key())
  end

  @doc false
  def notify(%VsGlobalChat.User{} = user) do
    Logger.info(user.name <> " has changed their user.")
    PubSub.broadcast(VsGlobalChat.PubSub, get_topic_key(), {"users_repo_changed", :changed})
  end

  def get_topic_key(), do: "users_repo"

  @doc false
  def list_users do
    Repo.all(from u in VsGlobalChat.User, where: u.permissions != :administrator) |> Repo.preload(:messages)
  end

  @doc false
  def get_user!(id) do
    Repo.get!((from u in VsGlobalChat.User, where: u.permissions != :administrator), id) |> Repo.preload(:messages)
  end

  def get_user_by_uid(uid) do
    Repo.one(from u in VsGlobalChat.User, where: u.uid == ^uid)
  end

  @doc false
  def get_system_messager() do
    Repo.one(from u in VsGlobalChat.User, where: u.permissions == :system)
  end

  @doc false
  def create_user(%VsGlobalChat.User{} = user) do
    changeset = changeset(user, %{})
    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, schema} ->
          notify(schema)
          {:ok, schema}
        {:error, error_changeset} ->
          {:error, error_changeset}
      end
    else
      {:error, changeset}
    end
  end

  @doc false
  def update_user(%VsGlobalChat.User{} = user, attrs) do
    changeset = changeset(user, attrs)
    if changeset.valid? do
      case Repo.update(changeset) do
        {:ok, schema} ->
          notify(schema)
          {:ok, schema}
        {:error, error_changeset} ->
          {:error, error_changeset}
      end
    else
      {:error, changeset.errors}
    end
  end

  @doc false
  def delete_user(%VsGlobalChat.User{} = user) do
    case Repo.delete(user) do
      {:ok, schema} ->
        notify(schema)
        {:ok, schema}
      {:error, error_changeset} ->
        {:error, error_changeset}
    end
  end

  @doc false
  def change_user(%VsGlobalChat.User{} = user, _attrs \\ %{}) do
    changeset(user, %{})
  end

  @doc false
  def toggle_ban_user(%VsGlobalChat.User{} = user) do
    update_user(user, %{banned: !user.banned})
  end

end
