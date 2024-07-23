defmodule VsGlobalChat.LiveViewFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VsGlobalChat.LiveView` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> VsGlobalChat.LiveView.create_user()

    user
  end
end
