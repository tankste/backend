defmodule Tankste.ReportWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :report_web

  @session_options [
    store: :cookie,
    key: "_tankste_report_key",
    signing_salt: "7EpfMn6q"
  ]

  plug Plug.Static,
    at: "/",
    from: :report_web,
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
  plug Tankste.ReportWeb.Router
end
