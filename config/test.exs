use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :grapevine, Web.Endpoint,
  http: [port: 4005],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
database = [
  adapter: Ecto.Adapters.Postgres,
  database: "grapevine_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
]
config :grapevine, Grapevine.Repo, database
config :backbone, Backbone.Repo, database

config :bcrypt_elixir, :log_rounds, 4

config :grapevine, :gossip, module: Test.Gossip

config :backbone, :repo, Grapevine.Repo
