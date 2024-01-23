defmodule Tankste.StationWeb.MarkerController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Markers

  def index(conn, %{"boundary" => boundary_param}) do
    markers = boundary_param
      |> boundary()
      |> Markers.gen_by_boundary()

    render(conn, "index.json", markers: markers)
  end
  def index(conn, _params) do
    conn
      |> put_status(:bad_request)
      |> put_view(ErrorView)
      |> render("400.json")
  end

  defp boundary(boundary_param) do
    boundary_param
      |> Enum.map(fn b -> b |> String.split(",") |> Enum.map(&String.to_float/1) end)
      |> Enum.map(fn b -> List.to_tuple(b) end)
  end
end
