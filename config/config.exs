# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :grapevine,
  namespace: Web,
  ecto_repos: [Backbone.Repo, Grapevine.Repo]

# Configures the endpoint
config :grapevine, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gLo4T/sAuCqIs27L8VG7IJ/0B59Ys1v10cxxePrwrssF5nGgr1y4paBfN5WTGCJ9",
  render_errors: [view: Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Grapevine.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :gossip, :callback_modules,
  core: Grapevine.GossipCallback,
  players: Grapevine.GossipCallback,
  tells: Grapevine.GossipCallback,
  games: Grapevine.GossipCallback
config :gossip, :system_module, Grapevine.GossipCallback.SystemCallback

config :grapevine, :gossip, module: Gossip

config :grapevine, :errors, report: false

config :backbone, :repo, Backbone.Repo

config :sentry, filter: Grapevine.SentryFilter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
