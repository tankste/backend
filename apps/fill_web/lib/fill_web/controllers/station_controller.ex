defmodule Tankste.FillWeb.StationController do
  use Tankste.FillWeb, :controller

  import Tankste.FillWeb.OriginTokenPlug

  alias Tankste.FillWeb.StationQueue

  plug :load_origin
  plug :require_current_origin

  def update(conn, %{"_json" => stations}) when is_list(stations) do
    origin_id = current_origin(conn).id
    StationQueue.add(stations |> Enum.map(fn s -> Map.put(s, "originId", origin_id) end))

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
