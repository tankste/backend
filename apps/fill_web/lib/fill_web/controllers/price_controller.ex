defmodule Tankste.FillWeb.PriceController do
  use Tankste.FillWeb, :controller

  alias Tankste.FillWeb.PriceQueue

  # TODO: auth + param validating
  # TODO: crawler header for origin
  # TODO: crawler token

  def update(conn, %{"_json" => prices}) when is_list(prices) do
    PriceQueue.add(prices)

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

  def delete(conn, _params) do
    # externalIds = []
    conn
  end
end
