defmodule Tankste.CockpitWeb.AuthPlug do
  import Plug.Conn

  alias Phoenix.Controller

  def load_current_user(conn, _opts \\ []) do
    case get_session(conn, :current_user) do
      nil ->
        assign(conn, :current_user, nil)
      user ->
        assign(conn, :current_user, user)
    end
  end

  def require_current_user(conn, _opts \\ []) do
    case current_user(conn) do
      nil ->
        conn
        |> Controller.put_flash(:error, "You must be logged in to access this page")
        |> Controller.redirect(to: "/auth")
        |> halt
      _ ->
        conn
    end
  end

  def current_user(conn), do: Map.get(conn.assigns, :current_user)
end
