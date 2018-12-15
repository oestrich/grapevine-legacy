use Mix.Config

config :grapevine, GrapevineWeb.Endpoint,
  secret_key_base: ""

config :grapevine, Web.Endpoint,
  url: [host: "", port: 443, scheme: "https"]

# Configure your database
database = [
  adapter: Ecto.Adapters.Postgres,
  database: "grapevine",
  pool_size: 15
]
config :grapevine, Grapevine.Repo, database
config :backbone, Backbone.Repo, database

config :gossip, :client_id, ""
config :gossip, :client_secret, ""

config :grapevine, :errors, report: true

config :grapevine, :gossip, base_url: "https://gossip.haus/"

config :sentry,
  dsn: "",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  tags: %{env: "production"},
  included_environments: [:prod]

config :grapevine, Grapevine.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "",
  port: 587,
  username: "",
  password: ""

config :pid_file, file: "/home/deploy/grapevine.pid"
