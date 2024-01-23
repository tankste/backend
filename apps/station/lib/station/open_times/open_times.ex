defmodule Tankste.Station.OpenTimes do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.OpenTimes.OpenTime
  alias Tankste.Station.StationAreas
  alias Tankste.Station.Holidays

  def list(opts \\ []) do
    query(opts)
    |> Repo.all()
  end

  def get(id, opts \\ []) do
    query(opts)
    |> where([ot], ot.id == ^id)
    |> Repo.one()
  end

  defp query(opts) do
    station_id = Keyword.get(opts, :station_id, nil)

    from(ot in OpenTime,
      select: ot)
    |> query_where_station_id(station_id)
  end

  defp query_where_station_id(query, nil), do: query
  defp query_where_station_id(query, []), do: query
  defp query_where_station_id(query, station_ids) when is_list(station_ids) do
    query
    |> where([ot], ot.station_id in ^station_ids)
  end
  defp query_where_station_id(query, station_id) do
    query
    |> where([ot], ot.station_id == ^station_id)
  end

  def insert(attrs \\ %{}) do
    %OpenTime{}
    |> OpenTime.changeset(attrs)
    |> Repo.insert()
  end

  def update(%OpenTime{} = open_time, attrs \\ %{}) do
    open_time
    |> OpenTime.changeset(attrs)
    |> Repo.update()
  end

  # TODO: use time zone based on station location
  def is_open(station_id) do
    case StationAreas.list(station_id: station_id) do
      [] ->
        is_in_open_time(station_id, :today)
      station_areas ->
        case Holidays.list(date: DateTime.now!("Europe/Berlin") |> DateTime.to_date(), area_id: station_areas |> Enum.map(fn sa -> sa.area_id end)) do
          [] ->
            is_in_open_time(station_id, :today)
          _holidays ->
            is_in_open_time(station_id, :holiday)
        end
    end
  end

  # TODO: use time zone based on station location
  defp is_in_open_time(station_id, :today) do
    now = DateTime.now!("Europe/Berlin")
    time_now = now |> DateTime.to_time()

    list(station_id: station_id, day: now |> DateTime.to_date() |> Date.day_of_week() |> day())
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= time_now && t.end_time >= time_now) end)
  end
  defp is_in_open_time(station_id, :holiday) do
    time_now =  DateTime.now!("Europe/Berlin") |> DateTime.to_time()

    list(station_id: station_id, day: "public_holiday")
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= time_now && t.end_time >= time_now) end)
  end

  defp day(1), do: "monday"
  defp day(2), do: "tuesday"
  defp day(3), do: "wednesday"
  defp day(4), do: "thursday"
  defp day(5), do: "friday"
  defp day(6), do: "saturday"
  defp day(7), do: "sunday"
  defp day(_), do: nil
end
