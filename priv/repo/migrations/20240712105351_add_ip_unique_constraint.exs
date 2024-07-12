defmodule VsGlobalChat.Repo.Migrations.AddIpUniqueConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:players, [:ip])
  end
end
