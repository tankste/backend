defmodule Tankste.StationWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :station_web

  @session_options [
    store: :cookie,
    key: "_tankste_station_key",
    signing_salt: "tWm5fyY4"
  ]

  plug Plug.Static,
    at: "/",
    from: :station_web,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Tankste.StationWeb.Router
end
