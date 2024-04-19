defmodule Tankste.Station.OpenTimes do
  import Ecto.Query, warn: false

  alias Tankste.Station.Repo
  alias Tankste.Station.OpenTimes.OpenTime
  alias Tankste.Station.StationAreas
  alias Tankste.Station.Areas
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
    station_info_id = Keyword.get(opts, :station_info_id, nil)
    day = Keyword.get(opts, :day, nil)

    from(ot in OpenTime,
      select: ot)
    |> query_where_station_info_id(station_info_id)
    |> query_where_day(day)
  end

  defp query_where_station_info_id(query, nil), do: query
  defp query_where_station_info_id(query, []), do: query
  defp query_where_station_info_id(query, station_info_ids) when is_list(station_info_ids) do
    query
    |> where([ot], ot.station_info_id in ^station_info_ids)
  end
  defp query_where_station_info_id(query, station_info_id) do
    query
    |> where([ot], ot.station_info_id == ^station_info_id)
  end

  defp query_where_day(query, nil), do: query
  defp query_where_day(query, []), do: query
  defp query_where_day(query, day) when is_list(day) do
    query
    |> where([ot], ot.day in ^day)
  end
  defp query_where_day(query, day) do
    query
    |> where([ot], ot.day == ^day)
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
  def is_open(station_info) do
    case station_station_areas(station_info) do
      [] ->
        is_in_open_time(station_info, :today)
      _station_areas ->
        case station_holidays(station_info, DateTime.now!("Europe/Berlin") |> DateTime.to_date()) do
          [] ->
            is_in_open_time(station_info, :today)
          _holidays ->
            is_in_open_time(station_info, :holiday)
        end
    end
  end

  def is_today(%OpenTime{station_info_id: station_info_id, day: "public_holiday"}) do
    station_area_ids = StationAreas.list(station_info_id: station_info_id) |> Enum.map(fn sa -> sa.area_id end)
    case Holidays.list(date: DateTime.now!("Europe/Berlin") |> DateTime.to_date(), area_id: station_area_ids) do
      [] ->
        false
      _holidays ->
        true
    end
  end
  def is_today(%OpenTime{day: day}) do
    case DateTime.now!("Europe/Berlin") |> DateTime.to_date() |> Date.day_of_week() |> day() do
      ^day ->
        true
      _ ->
        false
    end
  end

  # TODO: use time zone based on station location
  defp is_in_open_time(station_info, :today) do
    now = DateTime.now!("Europe/Berlin")
    time_now = now |> DateTime.to_time()

    station_open_times(station_info, now |> DateTime.to_date() |> Date.day_of_week() |> day())
    |> Enum.map(fn t -> Map.put(t, :end_time, to_end_time(t.end_time)) end)
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= time_now && t.end_time >= time_now)  end)
  end
  defp is_in_open_time(station_info, :holiday) do
    time_now =  DateTime.now!("Europe/Berlin") |> DateTime.to_time()

    station_open_times(station_info, "public_holiday")
    |> Enum.map(fn t -> Map.put(t, :end_time, to_end_time(t.end_time)) end)
    |> Enum.any?(fn t -> t.start_time == t.end_time or (t.start_time <= time_now && t.end_time >= time_now) end)
  end

  defp station_station_areas(station_info) do
    case Ecto.assoc_loaded?(station_info.station_areas) do
      true ->
        station_info.station_areas
      false ->
        StationAreas.list(station_info_id: station_info.id)
    end
  end

  defp station_holidays(station_info, day) do
    station_areas = station_station_areas(station_info)
    areas = station_areas |> Enum.map(fn sa -> station_area_area(sa) end)

    areas
    |> Enum.map(fn area ->
      case Ecto.assoc_loaded?(area.holidays) do
        true ->
          area.holidays |> Enum.filter(fn h -> h.date == day end)
        false ->
          Holidays.list(date: day, area_id: station_areas |> Enum.map(fn sa -> sa.area_id end))
      end
    end)
    |> List.flatten()
  end

  defp station_area_area(station_area) do
    case Ecto.assoc_loaded?(station_area.area) do
      true ->
        station_area.area
      false ->
        Areas.get(station_area.area_id)
    end
  end

  defp station_open_times(station_info, day) do
    case Ecto.assoc_loaded?(station_info.open_times) do
      true ->
        station_info.open_times |> Enum.filter(fn ot -> ot.day == day end)
      false ->
        list(station_info_id: station_info.id, day: day)
    end
  end

  defp to_end_time(~T[00:00:00]), do: ~T[23:59:59.999999]
  defp to_end_time(time), do: time

  defp day(1), do: "monday"
  defp day(2), do: "tuesday"
  defp day(3), do: "wednesday"
  defp day(4), do: "thursday"
  defp day(5), do: "friday"
  defp day(6), do: "saturday"
  defp day(7), do: "sunday"
  defp day(_), do: nil
end
