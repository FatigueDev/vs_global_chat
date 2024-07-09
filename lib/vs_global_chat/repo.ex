defmodule VsGlobalChat.Repo do
  use Ecto.Repo,
    otp_app: :vs_global_chat,
    adapter: Ecto.Adapters.Postgres
end
