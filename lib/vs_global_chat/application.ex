defmodule VsGlobalChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VsGlobalChatWeb.Telemetry,
      VsGlobalChat.Repo,
      {Cachex, name: VsGlobalChat.Cache.cache_name()},
      {DNSCluster, query: Application.get_env(:vs_global_chat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VsGlobalChat.PubSub},
      VsGlobalChat.Presence,
      # Start a worker by calling: VsGlobalChat.Worker.start_link(arg)
      # {VsGlobalChat.Worker, arg},
      # Start to serve requests, typically the last entry
      VsGlobalChatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VsGlobalChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VsGlobalChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
