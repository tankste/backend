# Execute this seed with `mix run apps/station/priv/repo/seeds.exs`

Tankste.Station.Repo.insert!(%Tankste.Station.Stations.Station{external_id: "1", origin: "seed", name: "NORDOEL", brand: "NORDOEL", address_street: "Lindemannallee", address_house_number: "25", address_post_code: "30173", address_city: "Hannover", address_country: "Deutschland", location_latitude: 52.437, location_longitude: 13.271, last_changes_at: DateTime.utc_now() |> DateTime.truncate(:second)})
