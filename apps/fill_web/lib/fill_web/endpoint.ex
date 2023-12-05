defmodule Tankste.FillWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :fill_web

  @session_options [
    store: :cookie,
    key: "_tankste_fill_key",
    signing_salt: "Dy64gMkT"
  ]

  plug Plug.Static,
    at: "/",
    from: :fill_web,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library(),
    length: 100_000_000

  # Log endpoint requests
  plug Plug.Telemetry,
    event_prefix: [:phoenix, :endpoint]

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Tankste.FillWeb.Router
end
