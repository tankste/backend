import Config

# Station
config :station, Tankste.Station.Repo,
  username: "root",
  # password: "root",
  database: "tankste_station_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 20

# Sponsor
config :sponsor, Tankste.Sponsor.Repo,
  username: "root",
  # password: "root",
  database: "tankste_sponsor_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Report
config :report, Tankste.Report.Repo,
  username: "root",
  # password: "root",
  database: "tankste_report_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Station Web
config :station_web, Tankste.StationWeb.Endpoint,
  http: [port: 4000],
  url: [host: "localhost"],
  secret_key_base: "OrSLcaXYmTmTesZg7xRNAHf5vE6mod5m+t8fB1Xei5n7jpJ+GDdIEWrW7j968a3r",
  live_view: [signing_salt: "D6dg3fGL"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Fill Web
config :fill_web, Tankste.FillWeb.Endpoint,
  http: [port: 4001],
  url: [host: "localhost"],
  secret_key_base: "OrSLcaXYmTmTesZg7xRNAHf5vE6mod5m+t8fB1Xei5n7jpJ+GDdIEWrW7j968a3r",
  live_view: [signing_salt: "D6dg3fGL"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Sponsor Web
config :sponsor_web, Tankste.SponsorWeb.Endpoint,
  http: [port: 4002],
  url: [host: "localhost"],
  secret_key_base: "OrSLcaXYmTmTesZg7xRNAHf5vE6mod5m+t8fB1Xei5n7jpJ+GDdIEWrW7j968a3r",
  live_view: [signing_salt: "D6dg3fGL"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Report Web
config :report_web, Tankste.ReportWeb.Endpoint,
  http: [port: 4003],
  url: [host: "localhost"],
  secret_key_base: "OrSLcaXYmTmTesZg7xRNAHf5vE6mod5m+t8fB1Xei5n7jpJ+GDdIEWrW7j968a3r",
  live_view: [signing_salt: "D6dg3fGL"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Cockpit Web
config :cockpit_web, Tankste.CockpitWeb.Endpoint,
  http: [port: 4004],
  url: [host: "localhost"],
  secret_key_base: "OrSLcaXYmTmTesZg7xRNAHf5vE6mod5m+t8fB1Xei5n7jpJ+GDdIEWrW7j968a3r",
  live_view: [signing_salt: "D6dg3fGL"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

config :cockpit_web, Tankste.CockpitWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [port: 4004],
  url: [host: "localhost"],
  secret_key_base: "OrSLcaXYmTmTesZg7xRNAHf5vE6mod5m+t8fB1Xei5n7jpJ+GDdIEWrW7j968a3r",
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:cockpit_web, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:cockpit_web, ~w(--watch)]}
  ]

config :cockpit_web, Tankste.CockpitWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/cockpit_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n",
  level: :debug

config :sponsor, :goth, source: %{}

config :fill_web, :origin,
  tokens: %{
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
  }

config :report_web, :origin,
  tokens: %{
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4
  }

config :cockpit_web, :auth,
  logins: %{
    "admin" => "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918" # admin:admin
  }

# Appended to all modules, so cronjobs are configured 4 times.
config :station, Tankste.Station.Scheduler,
  jobs: [
    {"0 0 * * *", {Tankste.Station.ClosingJob, :run, []}},
    {"*/15 * * * *", {Tankste.Station.PriceSnapshotJob, :run, []}}
  ]

config :station, :stats,
  host: "",
  credentials: "",
  table: ""

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view, :debug_heex_annotations, true

config :phoenix, :stacktrace_depth, 20


# TODO: auto generated config for cockpit

# # Configure your database
# config :cockpit_web, Tankste.CockpitWeb.Repo,
#   username: "postgres",
#   password: "postgres",
#   hostname: "localhost",
#   database: "cockpit_web_dev",
#   stacktrace: true,
#   show_sensitive_data_on_connection_error: true,
#   pool_size: 10

# # For development, we disable any cache and enable
# # debugging and code reloading.
# #
# # The watchers configuration can be used to run external
# # watchers to your application. For example, we can use it
# # to bundle .js and .css sources.
# config :cockpit_web, Tankste.CockpitWeb.Endpoint,
#   # Binding to loopback ipv4 address prevents access from other machines.
#   # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
#   http: [ip: {127, 0, 0, 1}, port: 4000],
#   check_origin: false,
#   code_reloader: true,
#   debug_errors: true,
#   secret_key_base: "5YiKND4TMYpBF9rZ/dnw0b0Jye8VIqKL1rOY+erY71+2xEEqDESi+g9ugzQW3CnO",
#   watchers: [
#     esbuild: {Esbuild, :install_and_run, [:cockpit_web, ~w(--sourcemap=inline --watch)]},
#     tailwind: {Tailwind, :install_and_run, [:cockpit_web, ~w(--watch)]}
#   ]

# # ## SSL Support
# #
# # In order to use HTTPS in development, a self-signed
# # certificate can be generated by running the following
# # Mix task:
# #
# #     mix phx.gen.cert
# #
# # Run `mix help phx.gen.cert` for more information.
# #
# # The `http:` config above can be replaced with:
# #
# #     https: [
# #       port: 4001,
# #       cipher_suite: :strong,
# #       keyfile: "priv/cert/selfsigned_key.pem",
# #       certfile: "priv/cert/selfsigned.pem"
# #     ],
# #
# # If desired, both `http:` and `https:` keys can be
# # configured to run both http and https servers on
# # different ports.

# # Watch static and templates for browser reloading.
# config :cockpit_web, Tankste.CockpitWeb.Endpoint,
#   live_reload: [
#     patterns: [
#       ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
#       ~r"priv/gettext/.*(po)$",
#       ~r"lib/cockpit_web/(controllers|live|components)/.*(ex|heex)$"
#     ]
#   ]

# # Enable dev routes for dashboard and mailbox
# config :cockpit_web, dev_routes: true

# # Do not include metadata nor timestamps in development logs
# config :logger, :console, format: "[$level] $message\n"

# # Set a higher stacktrace during development. Avoid configuring such
# # in production as building large stacktraces may be expensive.
# config :phoenix, :stacktrace_depth, 20

# # Initialize plugs at runtime for faster development compilation
# config :phoenix, :plug_init_mode, :runtime

# # Include HEEx debug annotations as HTML comments in rendered markup
# config :phoenix_live_view, :debug_heex_annotations, true

# # Disable swoosh api client as it is only required for production adapters.
# config :swoosh, :api_client, false
