defmodule VsGlobalChat.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string, null: false
      add :uid, :string, null: false, unique: true
      add :banned, :boolean, default: false, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:players, [:uid])
  end
end
