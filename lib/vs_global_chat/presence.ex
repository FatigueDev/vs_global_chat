defmodule VsGlobalChat.Presence do
  @moduledoc false
  use Phoenix.Presence,
    otp_app: :vs_global_chat,
    pubsub_server: VsGlobalChat.PubSub

  @presence_topic "vs_global_chat_presence"

  def topic(), do: @presence_topic
  def track(socket, key, meta), do: Presence.track(socket, @presence_topic, key, meta)
  def subscribe(), do: Phoenix.PubSub.subscribe(VsGlobalChat.PubSub, @presence_topic)
end
