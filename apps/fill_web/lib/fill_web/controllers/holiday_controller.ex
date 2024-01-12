defmodule Tankste.FillWeb.HolidayController do
  use Tankste.FillWeb, :controller

  import Tankste.FillWeb.OriginTokenPlug

  alias Tankste.FillWeb.HolidayQueue

  plug :load_origin
  plug :require_current_origin

  def update(conn, %{"_json" => holidays}) when is_list(holidays) do
    origin_id = current_origin(conn).id
    HolidayQueue.add(holidays |> Enum.map(fn h -> Map.put(h, "originId", origin_id) end))

    conn
    |> put_status(:no_content)
    |> send_resp(204, "")
  end
  def update(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json")
  end
end
