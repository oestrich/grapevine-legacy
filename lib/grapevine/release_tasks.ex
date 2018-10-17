# From https://github.com/bitwalker/distillery/blob/master/docs/Running%20Migrations.md
defmodule Grapevine.ReleaseTasks do
  @moduledoc false

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  @apps %{
    backbone: [Backbone.Repo],
    grapevine: [Grapevine.Repo]
  }

  def migrate() do
    startup()

    # Run migrations
    Enum.each(@apps, &run_migrations_for/1)

    # Signal shutdown
    IO.puts("Success!")
    :init.stop()
  end

  defp startup() do
    IO.puts("Loading grapevine...")

    # Load the code for grapevine, but don't start it
    Application.load(:grapevine)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    repos = List.flatten(Map.values(@apps))

    # Start the Repo(s) for grapevine
    IO.puts("Starting repos..")
    Enum.each(repos, & &1.start_link(pool_size: 1))
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for({app, repos}) do
    IO.puts("Running migrations for #{app}")
    Enum.each(repos, fn repo ->
      Ecto.Migrator.run(repo, migrations_path(app), :up, all: true)
    end)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end
