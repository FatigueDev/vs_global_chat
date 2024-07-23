defmodule VsGlobalChat.AdministrationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VsGlobalChat.Administration` context.
  """

  @doc """
  Generate a none.
  """
  def none_fixture(attrs \\ %{}) do
    {:ok, none} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> VsGlobalChat.Administration.create_none()

    none
  end
end
