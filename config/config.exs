import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Station
config :station,
  ecto_repos: [Tankste.Station.Repo]

# Station Web
config :station_web, Tankste.StationWeb.Endpoint,
  pubsub_server: Tankste.StationWeb.PubSub,
  render_errors: [view: Tankste.StationWeb.ErrorView, accepts: ~w(html json), layout: false]

# Fill Web
config :fill_web, Tankste.FillWeb.Endpoint,
  pubsub_server: Tankste.FillWeb.PubSub,
  render_errors: [view: Tankste.FillWeb.ErrorView, accepts: ~w(html json), layout: false]

config :fill_web, :processor, []

config :fill_web, :origin,
  tokens: %{}

# Sponsor
config :sponsor,
  ecto_repos: [Tankste.Sponsor.Repo]

# Sponsor Web
config :sponsor_web, Tankste.SponsorWeb.Endpoint,
  pubsub_server: Tankste.SponsorWeb.PubSub,
  render_errors: [view: Tankste.SponsorWeb.ErrorView, accepts: ~w(html json), layout: false]

# Report
config :report,
  ecto_repos: [Tankste.Report.Repo]

# Report Web
config :report_web, Tankste.ReportWeb.Endpoint,
  pubsub_server: Tankste.ReportWeb.PubSub,
  render_errors: [view: Tankste.ReportWeb.ErrorView, accepts: ~w(html json), layout: false]

import_config "#{config_env()}.exs"
