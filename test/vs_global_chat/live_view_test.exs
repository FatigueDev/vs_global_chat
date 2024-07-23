defmodule VsGlobalChat.LiveViewTest do
  use VsGlobalChat.DataCase

  alias VsGlobalChat.LiveView

  describe "users" do
    alias VsGlobalChat.LiveView.User

    import VsGlobalChat.LiveViewFixtures

    @invalid_attrs %{}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert LiveView.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert LiveView.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{}

      assert {:ok, %User{} = user} = LiveView.create_user(valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LiveView.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{}

      assert {:ok, %User{} = user} = LiveView.update_user(user, update_attrs)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = LiveView.update_user(user, @invalid_attrs)
      assert user == LiveView.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = LiveView.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> LiveView.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = LiveView.change_user(user)
    end
  end
end
