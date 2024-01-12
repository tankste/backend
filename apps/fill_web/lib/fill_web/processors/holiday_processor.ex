defmodule Tankste.FillWeb.HolidayProcessor do
  use GenStage

  alias Tankste.Station.Areas
  alias Tankste.Station.Holidays

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [])
  end

  @impl true
  def init(_args) do
    {:consumer, [], subscribe_to: [{Tankste.FillWeb.HolidayQueue, [max_demand: 100]}]}
  end

  @impl true
  def handle_events(holidays, _from, _state) do
    process_holidays(holidays)
  end

  defp process_holidays([]) do
    {:noreply, [], []}
  end
  defp process_holidays([holiday|holidays]) do
    case upsert_holiday(holiday) do
      {:ok, _updated_holiday} ->
        process_holidays(holidays)
      {:error, changeset} ->
        IO.inspect(changeset)
        {:stop, :failed, []}
    end
  end

  defp upsert_holiday(new_holiday) do
    case Areas.get_by_key(new_holiday["areaKey"]) do
      nil ->
        {:error, :invalid_area}
      area ->
        case Holidays.get_by_date_and_area_id(new_holiday["date"], area.id) do
          nil ->
            Holidays.create(%{
              origin_id: new_holiday["originId"],
              area_id: area.id,
              date: new_holiday["date"],
              name: new_holiday["name"]
            })
          holiday ->
            Holidays.update(holiday, %{
              origin_id: new_holiday["originId"],
              area_id: area.id,
              date: new_holiday["date"],
              name: new_holiday["name"]
            })
        end
    end
  end
end
