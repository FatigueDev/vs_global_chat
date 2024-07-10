defmodule VsGlobalChat.Message do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias VsGlobalChat.Repo
  alias Phoenix.PubSub
  alias __MODULE__

  schema "messages" do
    field :message, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
    |> validate_length(:message, min: 2)
  end

  def create_message(attrs) do
    %Message{}
    |> changeset(attrs)
    |> Repo.insert()
    |> notify(:message_created)
  end

  def list_messages do
    Message
    |> limit(20)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def subscribe() do
    PubSub.subscribe(VsGlobalChat.PubSub, "liveview_chat")
  end

  def notify({:ok, message}, event) do
    PubSub.broadcast(VsGlobalChat.PubSub, "liveview_chat", {event, message})
  end

  def notify({:error, reason}, _event), do: {:error, reason}
end
