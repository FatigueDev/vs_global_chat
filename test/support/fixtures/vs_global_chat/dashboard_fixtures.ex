defmodule VsGlobalChat.VsGlobalChat.DashboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VsGlobalChat.VsGlobalChat.Dashboard` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> VsGlobalChat.VsGlobalChat.Dashboard.create_user()

    user
  end
end
