defmodule VsGlobalChat.MixProject do
  use Mix.Project

  def project do
    [
      app: :vs_global_chat,
      version: "0.1.0",
      elixir: "~> 1.17.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      compilers: Mix.compilers() ++ [:surface]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {VsGlobalChat.Application, []},
      extra_applications: [:logger_file_backend, :logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.1.0"},
      {:phoenix, "~> 1.7.14"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:remote_ip, "~> 1.2.0"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_ddos, "~> 1.1.19"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.0-rc.1", override: true},
      {:phoenix_html_sanitizer, git: "https://github.com/aboard-io/phoenix_html_sanitizer.git"},
      {:mochiweb, "~> 3.2.2", override: true},
      {:surface, "~> 0.11.4"},
      {:surface_bulma, "~> 0.5.2"},
      {:poison, "6.0.0"},
      {:httpoison, "2.2.1"},
      {:protobuf, "~> 0.12.0"},
      {:google_protos, "~> 0.4.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:logger_file_backend, "0.0.14"},
      {:logflare_logger_backend, "~> 0.11.4", only: :prod},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:gettext, "0.24.0"},
      {:timex, "~> 3.7.11"},
      {:cachex, "~> 3.6.0"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["esbuild.install --if-missing"],
      "assets.build": ["esbuild vs_global_chat"],
      "assets.deploy": [
        "esbuild vs_global_chat --minify",
        "phx.digest"
      ]
    ]
  end
end
