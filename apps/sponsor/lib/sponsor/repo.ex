defmodule Tankste.Sponsor.Repo do
  use Ecto.Repo,
    otp_app: :sponsor,
    adapter: Ecto.Adapters.MyXQL
end
