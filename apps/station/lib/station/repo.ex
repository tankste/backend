defmodule Tankste.Station.Repo do
  use Ecto.Repo,
    otp_app: :station,
    adapter: Ecto.Adapters.MyXQL
end
