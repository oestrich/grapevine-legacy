defmodule Grapevine.Mixfile do
  use Mix.Project

  def project do
    [
      app: :grapevine,
      version: "0.1.0",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Grapevine.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:backbone, git: "https://github.com/oestrich/gossip-backbone.git"},
      {:bamboo, "~> 1.0"},
      {:bamboo_smtp, "~> 1.5"},
      {:bcrypt_elixir, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:cowboy, "~> 2.0"},
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false},
      {:distillery, "~> 2.0", runtime: false},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:elixir_uuid, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:gossip, "~> 1.0"},
      {:phoenix, "~> 1.4.0-rc.3", override: true},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.2-rc.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:pid_file, "~> 0.1.0"},
      {:plug_cowboy, "~> 2.0", override: true},
      {:postgrex, ">= 0.0.0"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1.1"},
      {:sentry, "~> 7.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.migrate.reset": ["ecto.drop", "ecto.create", "ecto.migrate"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
