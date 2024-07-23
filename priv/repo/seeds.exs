# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     VsGlobalChat.Repo.insert!(%VsGlobalChat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto
import Ecto.Query
alias VsGlobalChat.{Repo, User, Message}

# dbg "Delete seeds"
# Repo.delete_all(Message) |> dbg
# Repo.delete_all(User) |> dbg

# Create our user
# dbg "Create user"
# admin_changeset = User.changeset(%User{}, %{auth_token: "71ea5396-6197-443a-98e7-5076c7753dae", name: "Fatigue", uid: "Lh94AhstlmYPAhdVhRPkhsS2", permissions: :administrator})
# {:ok, admin_result} = Repo.insert(admin_changeset)

dbg "Create user"
system_user_changeset = User.changeset(%User{}, %{auth_token: "1ea5396-6197-443a-98e7-5076c7753dae", name: "VSGC Admin", uid: "1ea5396-6197-443a-98e7-5076c7753dae-bacongrease", permissions: :system})
Repo.insert(system_user_changeset)

# Enum.each([
#   User.changeset(%User{}, %{auth_token: "qwerty", name: "Test", uid: "grundle"}),
#   User.changeset(%User{}, %{auth_token: "e", name: "Test 2", uid: "qwe11"})
# ], fn el -> Repo.insert(el) end)

# user_changeset = User.changeset(%User{}, %{auth_token: "has_messages", name: "User Has Messages", uid: "has_messages_UID"})
# {:ok, user_result} = Repo.insert(user_changeset)

# #Create a message and link it to that new user
# dbg "Create first message"
# message_assoc = build_assoc(%User{}, :messages, %{user: user_result})
# message_changeset = Message.changeset(message_assoc, %{text: "<script>alert(\"Hello World\")</script><h1>This had text, once.</h1>"})
# {:ok, message_result} = Repo.insert(message_changeset)

# #Create a second message
# dbg "Create second message"
# message_assoc = build_assoc(%User{}, :messages, %{user: user_result})
# message_changeset = Message.changeset(message_assoc, %{text: "Test Message 2"})
# {:ok, message_result_two} = Repo.insert(message_changeset)

# #Update the user with the new association
# dbg "Associate user with message 1"
