defmodule VsGlobalChat.FakeThingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VsGlobalChat.FakeThing` context.
  """

  @doc """
  Generate a fake.
  """
  def fake_fixture(attrs \\ %{}) do
    {:ok, fake} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> VsGlobalChat.FakeThing.create_fake()

    fake
  end
end
