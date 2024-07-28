defmodule VsGlobalChatWeb.Components.Dashboard do
  use Surface.LiveComponent

  alias VsGlobalChatWeb.Components.Table
  alias SurfaceBulma.Table.Column

  use PhoenixHtmlSanitizer, :strip_tags

  import VsGlobalChat.Helpers.Time

  alias VsGlobalChatWeb.Components.SendMessageComponent
  # alias Surface.Components.Context
  alias SurfaceBulma.Button
  alias VsGlobalChat.{User, Message}
  alias VsGlobalChatWeb.Components.UsersComponent
  alias VsGlobalChatWeb.Components.MessagesComponent

  alias VsGlobalChatWeb.Components.Table
  alias SurfaceBulma.Table.Column
  # alias SurfaceBulma.Modal
  alias SurfaceBulma.Panel
  alias SurfaceBulma.Tab

  data show_user_modal, :boolean, from_context: :show_user_modal
  data modal_user, :struct, from_context: :modal_user
  data message_base, :string, default: "Messages"

  def render(assigns) do
    ~F"""
    <div>
      <Panel id>
        <:title>
          <h3 class="title has-text-centered is-3">Toolkit</h3>
        </:title>
        <Tab label="Users" icon="users">
          <UsersComponent id="users_component" />
        </Tab>
        <Tab label={@message_base} icon="comments">
          <SendMessageComponent id="send_message_component" />
          <MessagesComponent id="messages_component" />
        </Tab>
      </Panel>

      <VsGlobalChatWeb.Components.Card show={@show_user_modal}>
        <:header>
          {#if @modal_user != nil}
            {@modal_user.name}
            {#if @modal_user.permissions not in [:system, :administrator]}
              <Button click="toggle_ban_user">{if @modal_user.banned, do: "Unban", else: "Ban"}</Button>
            {/if}
          {#else}
            No user found
          {/if}
        </:header>
        {#if @modal_user != nil}
          <Table
            id="modal_message_table"
            data={message <- Enum.sort(@modal_user.messages, &(&1.inserted_at >= &2.inserted_at))}
            hoverable
            striped
          >
            <Column label="Created">
              {time_relative(message.inserted_at)}
            </Column>
            <Column label="Text">
              {sanitize(message.text)}
            </Column>
          </Table>
        {#else}
          No content
        {/if}
      </VsGlobalChatWeb.Components.Card>
    </div>
    """
  end

  def handle_event("toggle_ban_user", _, socket) do
    User.toggle_ban_user(Context.get(socket, :modal_user))
    {:noreply, socket}
  end
end
