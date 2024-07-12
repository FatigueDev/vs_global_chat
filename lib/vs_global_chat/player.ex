defmodule VsGlobalChat.Player do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :uid, :string
    field :banned, :boolean, default: false
    field :ip, :string, default: "", redact: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :uid, :banned, :ip])
    |> validate_required([:name, :uid, :ip])
    |> unique_constraint(:uid, message: "A player with this UID is already in the system.")
    |> unique_constraint(:ip, message: "A player with this IP is already in the system.")
  end
end
