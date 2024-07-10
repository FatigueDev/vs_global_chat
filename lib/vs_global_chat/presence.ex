defmodule VsGlobalChat.Presence do
  use Phoenix.Presence,
    otp_app: :vs_global_chat,
    pubsub_server: VsGlobalChat.PubSub
end
