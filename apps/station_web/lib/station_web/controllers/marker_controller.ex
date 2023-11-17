defmodule Tankste.StationWeb.MarkerController do
  use Tankste.StationWeb, :controller

  alias Tankste.Station.Markers

  # TODO: limit requests to max ~0.2 degree
  # TODO: fall back request
  def index(conn, %{"boundary" => boundary_param}) do
    boundary = boundary_param
      |> Enum.map(fn b -> b |> String.split(",") |> Enum.map(&String.to_float/1) end)
      |> Enum.map(fn b -> List.to_tuple(b) end)

    markers = Markers.list(boundary: boundary)
    #TODO: validate open times & replace null comparisation by enum
    render(conn, "index.json", markers: markers)
  end
end
