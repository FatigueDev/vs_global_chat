defmodule :"Elixir.VsGlobalChat.Repo.Migrations.AddIpToPlayerSchema.ex" do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :ip, :text
    end
  end
end
