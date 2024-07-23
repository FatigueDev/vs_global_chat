defmodule VsGlobalChat.Message do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Phoenix.PubSub
  alias VsGlobalChat.{Repo, User, Message}

  schema "messages" do
    belongs_to :user, VsGlobalChat.User
    field :text, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text])
    |> cast_assoc(:user)
    |> validate_required([:user, :text])
  end

  @doc false
  def subscribe() do
    PubSub.subscribe(VsGlobalChat.PubSub, get_topic_key())
  end

  @doc false
  def notify(%VsGlobalChat.Message{} = message) do
    Logger.info(message.user.name <> " sent " <> message.text)
    PubSub.broadcast(VsGlobalChat.PubSub, get_topic_key(), {"messages_repo_changed", message})
  end

  @doc false
  def get_topic_key(), do: "messages_repo"

  @doc false
  def list_messages do
    Repo.all(Message) |> Repo.preload(:user)
  end

  @doc false
  def create(user, text) do
    assoc = Ecto.build_assoc(%User{}, :messages, %{user: user})
    changeset = Message.changeset(assoc, %{text: text})
    case Repo.insert(changeset) do
      {:ok, schema} ->
        notify(schema)
        {:ok, schema}
      {:error, error_set} ->
        {:error, error_set}
    end
  end

  @doc false
  def for_user(user_id) do
    Repo.all(from m in Message, where: m.user_id == ^user_id)
  end

  @doc false
  def get_user_from_message_id(message_id) do
    user_id = Repo.one(from m in Message, where: m.id == ^message_id, select: m.user_id)
    User.get_user!(user_id)
  end
end
