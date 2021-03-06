use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :grapevine, Web.Endpoint,
  http: [port: 4002],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :grapevine, Web.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/grapevine_web/views/.*(ex)$},
      ~r{lib/grapevine_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
database = [
  database: "grapevine_dev",
  hostname: "localhost",
  pool_size: 10
]
config :grapevine, Grapevine.Repo, database
config :backbone, Backbone.Repo, database

# This is the grapevine keys that gossip has in its seeds
config :gossip, :url, "ws://localhost:4001/socket"
config :gossip, :client_id, "e16a2503-6153-48a9-9e92-3d087b9cc6d7"
config :gossip, :client_secret, "3de1854f-6f3a-49f4-a7f2-bc01a18c8369"

config :grapevine, Grapevine.Mailer, adapter: Bamboo.LocalAdapter

config :grapevine, :gossip, base_url: "http://localhost:4001/"

if File.exists?("config/dev.local.exs") do
  import_config("dev.local.exs")
end
