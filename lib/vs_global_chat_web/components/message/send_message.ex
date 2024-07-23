defmodule VsGlobalChatWeb.Components.SendMessageComponent do
  use VsGlobalChatWeb, :live_surface_component

  alias Phoenix.LiveView.JS

  alias Surface.Components.Context
  alias VsGlobalChat.Message

  alias SurfaceBulma.Form

  data message_value, :string, default: ""

  slot default

  def render(assigns) do
    ~F"""
    <div class="mt-2 mb-2">
      <div class="columns is-flex is-vcentered">
        <div class="column ml-2 is-narrow">
          <Form.Label text="Send Message:" />
        </div>
        <div class="column mr-6">
          <input id={"send_message_text_input"} :hook :on-keydown={"event_send_message"} class="input" type="text"  value={@message_value} />
        </div>
      </div>
    </div>
    """
  end

  def handle_event("event_send_message", %{"key" => "Enter", "value" => value}, socket) do

    Message.create(VsGlobalChat.User.get_system_messager(), value)

    socket =
      socket
      |> assign(:message_value, "")
      |> Phoenix.LiveView.push_event("clear_after_sending_system_message", %{})

    {:noreply, socket}
  end

  def handle_event("event_send_message", %{"key" => _, "value" => value}, socket) do
    {:noreply, assign(socket, :message_value, value)}
  end

  # <Table id data={message <- @messages} striped>
  #       <Column label="Created">
  #         {time_relative(message.inserted_at)}
  #       </Column>
  #       <Column label="Sender">
  #         {message.user.name}
  #       </Column>
  #       <Column label="Text">
  #         {sanitize(message.text)}
  #       </Column>
  #     </Table>
end
