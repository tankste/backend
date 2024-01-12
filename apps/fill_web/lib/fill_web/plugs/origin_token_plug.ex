defmodule Tankste.FillWeb.OriginTokenPlug do
  import Plug.Conn

  alias Phoenix.Controller
  alias Tankste.Station.Origins

  def load_origin(conn, _opts \\ []) do
    case get_req_header(conn, "authorization") do
      ["origintoken " <> token] ->
        case tokens() |> Map.get(token, 0) |> Origins.get() do
          nil ->
            conn
            |> put_resp_header("WWW-Authenticate", "origintoken")
            |> put_status(:forbidden)
            |> Controller.put_view(Tankste.FillWeb.ErrorView)
            |> Controller.render("403.json")
            |> halt
          origin ->
            conn
            |> put_resp_header("WWW-Authenticate", "origintoken")
            |> assign(:current_origin, origin)
        end
      _ ->
        conn
        |> put_resp_header("WWW-Authenticate", "origintoken")
        |> put_status(:unauthorized)
        |> Controller.put_view(Tankste.FillWeb.ErrorView)
        |> Controller.render("401.json")
        |> halt
    end
  end

  def require_current_origin(conn, _opts \\ []) do
    case current_origin(conn) do
      nil ->
        conn
        |> put_resp_header("WWW-Authenticate", "sessiontoken")
        |> put_status(:unauthorized)
        |> Controller.put_view(Tankste.FillWeb.ErrorView)
        |> Controller.render("401.json")
        |> halt
      _origin ->
        conn
    end
  end

  def current_origin(conn), do: Map.get(conn.assigns, :current_origin)


  defp tokens(), do: origin_config() |> Keyword.get(:tokens, %{})

  defp origin_config(), do: Application.get_env(:fill_web, :origin)
end
