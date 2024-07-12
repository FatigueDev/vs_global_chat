# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :vs_global_chat,
  ecto_repos: [VsGlobalChat.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :vs_global_chat, VsGlobalChatWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [view: VsGlobalChatWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: VsGlobalChat.PubSub,
  live_view: [signing_salt: "ytx1yEP8"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  vs_global_chat: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Poison

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
