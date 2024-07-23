defmodule VsGlobalChat.Repo.Migrations.CreateUsersMessagesAndLink do
  use Ecto.Migration

  def change do
    create table("users") do
      add :uid, :string, null: false
      add :name, :string, null: false
      add :auth_token, :string, null: false
      add :banned, :boolean, null: false
      add :permissions, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index("users", [:auth_token, :uid])

    create table("messages") do
      add :text, :string
      add :user_id, references("users")

      timestamps(type: :utc_datetime)
    end

    create index("messages", :user_id)

    alter table("users") do
      add :message_ids, references("messages", when: [id: :user_id])
    end
  end
end
