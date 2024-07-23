defmodule VsGlobalChat.FakeThingTest do
  use VsGlobalChat.DataCase

  alias VsGlobalChat.FakeThing

  describe "fakes" do
    alias VsGlobalChat.FakeThing.Fake

    import VsGlobalChat.FakeThingFixtures

    @invalid_attrs %{name: nil}

    test "list_fakes/0 returns all fakes" do
      fake = fake_fixture()
      assert FakeThing.list_fakes() == [fake]
    end

    test "get_fake!/1 returns the fake with given id" do
      fake = fake_fixture()
      assert FakeThing.get_fake!(fake.id) == fake
    end

    test "create_fake/1 with valid data creates a fake" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Fake{} = fake} = FakeThing.create_fake(valid_attrs)
      assert fake.name == "some name"
    end

    test "create_fake/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FakeThing.create_fake(@invalid_attrs)
    end

    test "update_fake/2 with valid data updates the fake" do
      fake = fake_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Fake{} = fake} = FakeThing.update_fake(fake, update_attrs)
      assert fake.name == "some updated name"
    end

    test "update_fake/2 with invalid data returns error changeset" do
      fake = fake_fixture()
      assert {:error, %Ecto.Changeset{}} = FakeThing.update_fake(fake, @invalid_attrs)
      assert fake == FakeThing.get_fake!(fake.id)
    end

    test "delete_fake/1 deletes the fake" do
      fake = fake_fixture()
      assert {:ok, %Fake{}} = FakeThing.delete_fake(fake)
      assert_raise Ecto.NoResultsError, fn -> FakeThing.get_fake!(fake.id) end
    end

    test "change_fake/1 returns a fake changeset" do
      fake = fake_fixture()
      assert %Ecto.Changeset{} = FakeThing.change_fake(fake)
    end
  end
end
