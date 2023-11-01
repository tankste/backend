import Config

# Station
config :station,
  ecto_repos: [Tankste.Station.Repo]

# Station Web
config :station_web, Tankste.StationWeb.Endpoint,
  pubsub_server: Tankste.StationWeb.PubSub,
  render_errors: [view: Tankste.StationWeb.ErrorView, accepts: ~w(html json), layout: false]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
