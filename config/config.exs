import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Station
config :station,
  ecto_repos: [Tankste.Station.Repo]

config :station, Tankste.Station.Scheduler,
  jobs: [
    {"0 0 * * *", {Tankste.Station.ClosingJob, :run, []}},
    {"*/15 * * * *", {Tankste.Station.PriceSnapshotJob, :run, []}}
  ]

# Station Web
config :station_web, Tankste.StationWeb.Endpoint,
  pubsub_server: Tankste.StationWeb.PubSub,
  render_errors: [view: Tankste.StationWeb.ErrorView, accepts: ~w(html json), layout: false]

# Fill Web
config :fill_web, Tankste.FillWeb.Endpoint,
  pubsub_server: Tankste.FillWeb.PubSub,
  render_errors: [view: Tankste.FillWeb.ErrorView, accepts: ~w(html json), layout: false]

config :fill_web, :processor, []

config :fill_web, :origin, tokens: %{}

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

# Cockpit Web
config :cockpit_web, Tankste.CockpitWeb.Endpoint,
  pubsub_server: Tankste.CockpitWeb.PubSub,
  render_errors: [view: Tankste.CockpitWeb.ErrorView, accepts: ~w(html json), layout: false]

config :esbuild,
  version: "0.17.11",
  cockpit_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/cockpit_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.0",
  cockpit_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/cockpit_web/assets", __DIR__)
  ]

config :cockpit_web, :auth,
  logins: %{
  }

import_config "#{config_env()}.exs"


# TODO: auto-generate by phoenix

# config :cockpit_web,
#   namespace: Tankste.CockpitWeb,
#   ecto_repos: [Tankste.CockpitWeb.Repo],
#   generators: [timestamp_type: :utc_datetime]

# # Configures the endpoint
# config :cockpit_web, Tankste.CockpitWeb.Endpoint,
#   url: [host: "localhost"],
#   adapter: Bandit.PhoenixAdapter,
#   render_errors: [
#     formats: [html: Tankste.CockpitWeb.ErrorHTML, json: Tankste.CockpitWeb.ErrorJSON],
#     layout: false
#   ],
#   pubsub_server: Tankste.CockpitWeb.PubSub,
#   live_view: [signing_salt: "BCyPpaFT"]

# # Configures the mailer
# #
# # By default it uses the "Local" adapter which stores the emails
# # locally. You can see the emails in your browser, at "/dev/mailbox".
# #
# # For production it's recommended to configure a different adapter
# # at the `config/runtime.exs`.
# config :cockpit_web, Tankste.CockpitWeb.Mailer, adapter: Swoosh.Adapters.Local

# # Configure esbuild (the version is required)
# config :esbuild,
#   version: "0.17.11",
#   cockpit_web: [
#     args:
#       ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
#     cd: Path.expand("../apps/cockpit_web/assets", __DIR__),
#     env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
#   ]

# # Configure tailwind (the version is required)
# config :tailwind,
#   version: "3.4.0",
#   cockpit_web: [
#     args: ~w(
#       --config=tailwind.config.js
#       --input=css/app.css
#       --output=../priv/static/assets/app.css
#     ),
#     cd: Path.expand("../apps/cockpit_web/assets", __DIR__)
#   ]

# # Configures Elixir's Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]

# # Use Jason for JSON parsing in Phoenix
# config :phoenix, :json_library, Jason
