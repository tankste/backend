import Config

# Station
config :station, Tankste.Station.Repo,
  username: "root",
  # password: "root",
  database: "tankste_station_dev",
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

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :plug_init_mode, :runtime

config :phoenix, :stacktrace_depth, 20
