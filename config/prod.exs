import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
# config :vs_global_chat, VsGlobalChatWeb.Endpoint,
#   cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger,
  message: "$metadata[$level] $message\n",
  # metadata: [:remote_ip],
  level: :info,
  backends: [LogflareLogger.HttpBackend]

config :logflare_logger_backend,
  # https://api.logflare.app is configured by default and you can set your own url
  url: Map.fetch!(System.get_env(), "LOGFLARE_URL"),
  # Default LogflareLogger level is :info. Note that log messages are filtered by the :logger application first
  level: :info,
  # your Logflare API key, found on your dashboard
  api_key: Map.fetch!(System.get_env(), "LOGFLARE_API_KEY"),
  # the Logflare source UUID, found  on your Logflare dashboard
  source_id: Map.fetch!(System.get_env(), "LOGFLARE_SOURCE_ID"),
  # minimum time in ms before a log batch is sent
  flush_interval: 1_000,
  # maximum number of events before a log batch is sent
  max_batch_size: 50,
  # optionally you can drop keys if they exist with `metadata: [drop: [:list, :keys, :to, :drop]]`
  metadata: :all

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
config :vs_global_chat, VsGlobalChatWeb.Endpoint,
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  # ,
  server: true

# force_ssl: [rewrite_on: [:x_forwarded_proto]]

config :vs_global_chat, VsGlobalChat.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 2
