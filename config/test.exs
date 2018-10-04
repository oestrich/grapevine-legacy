use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :grapevine, Web.Endpoint,
  http: [port: 4005],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :grapevine, Grapevine.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "grapevine_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
