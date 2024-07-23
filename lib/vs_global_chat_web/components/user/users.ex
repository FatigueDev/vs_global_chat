defmodule VsGlobalChatWeb.Components.UsersComponent do
  use Surface.LiveComponent

  alias VsGlobalChatWeb.Components.Table
  alias SurfaceBulma.Table.Column
  # alias SurfaceBulma.Modal

  import VsGlobalChat.Helpers.Time

  data users, :list, from_context: :users

  slot default

  def render(assigns) do
    ~F"""
    <div>
      <Table id data={user <- @users} row_class={fn _, _ -> "is-clickable" end} row_click_event={"user_row_clicked"} hoverable striped>
        <Column label="Created" sort_by={fn i -> Map.get(i, :inserted_at) end}>
          {time_relative(user.inserted_at)}
        </Column>
        <Column label="Name" sort_by={fn i -> String.to_charlist(Map.get(i, :name)) end}>
          {user.name}
        </Column>
        <Column label="UID" sort_by={fn i -> String.to_charlist(Map.get(i, :uid)) end}>
          {user.uid}
        </Column>
        <Column label="Messages" sort_by={fn i -> Enum.count(Map.get(i, :messages, default: [])) end}>
          {Enum.count(user.messages)}
        </Column>
        <Column label="Banned" sort_by={fn i -> Map.get(i, :banned) end}>
          {if user.banned, do: "Banned", else: ""}
        </Column>
      </Table>
    </div>
    """
  end
end
