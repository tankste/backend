defmodule Tankste.SponsorWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :sponsor_web

  @session_options [
    store: :cookie,
    key: "_tankste_sponsor_key",
    signing_salt: "ptec2Rzu"
  ]

  plug Plug.Static,
    at: "/",
    from: :sponsor_web,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  # Log endpoint requests
  plug Plug.Telemetry,
    event_prefix: [:phoenix, :endpoint]

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Tankste.SponsorWeb.Router
end
