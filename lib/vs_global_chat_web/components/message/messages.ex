defmodule VsGlobalChatWeb.Components.MessagesComponent do
  use VsGlobalChatWeb, :live_surface_component

  alias VsGlobalChatWeb.Components.Table
  alias SurfaceBulma.Table.Column

  import VsGlobalChat.Helpers.Time

  data messages, :list, from_context: :messages

  slot default

  def render(assigns) do
    ~F"""
    <div>
      <Table id data={message <- Enum.sort(@messages, &(&1.inserted_at >= &2.inserted_at))} row_class={fn _, _ -> "is-clickable" end} row_click_event={"message_row_clicked"} striped>
        <Column label="Created">
          {time_relative(message.inserted_at)}
        </Column>
        <Column label="Sender">
          {message.user.name}
        </Column>
        <Column label="Text">
          {sanitize(message.text)}
        </Column>
      </Table>
    </div>
    """
  end
end
