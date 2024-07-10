defmodule VsGlobalChat.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :uid, :string
    field :banned, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :uid, :banned])
    |> validate_required([:name, :uid])
    |> unique_constraint(:uid, message: "This UID is already in use. What's going on?")
  end
end
