defmodule Tankste.CockpitWeb.StationController do
  use Tankste.CockpitWeb, :controller

  alias Tankste.Station.Repo
  alias Tankste.Station.StationInfos

  # TODO: clean up paging logic, too messy output today
  def index(conn, params) do
    search = Map.get(params, "search")

    all_station_infos = StationInfos.list(search: search)
    |> Enum.sort_by(fn si -> si.priority end, :desc)
    |> Enum.uniq_by(fn si -> si.station_id end)

    page = Map.get(params, "page", "0") |> String.to_integer()
    page_start = page * 50
    page_end = page_start + 49

    page_station_infos = all_station_infos |> Enum.slice(page_start..page_end) |> Repo.preload([:station])
    page_count = (page_station_infos |> length())
    stations_count = all_station_infos |> length()

    render(
      conn,
      :index,
      page_station_infos: page_station_infos,
      stations_count: stations_count,
      page_start: page_start,
      page_end: page_start + page_count - 1,
      previous_page: case page do
          0 -> nil
          _ -> page - 1
        end,
      next_page: case page_start + page_count do
          ^stations_count ->
            nil
          _ -> page + 1
        end,
      search: search || ""
    )
  end
end
