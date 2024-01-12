defmodule Tankste.FillWeb.PriceController do
  use Tankste.FillWeb, :controller

  import Tankste.FillWeb.OriginTokenPlug

  alias Tankste.FillWeb.PriceQueue

  plug :load_origin
  plug :require_current_origin

  def update(conn, %{"_json" => prices}) when is_list(prices) do
    origin_id = current_origin(conn).id
    PriceQueue.add(prices |> Enum.map(fn p -> Map.put(p, "originId", origin_id) end))

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
