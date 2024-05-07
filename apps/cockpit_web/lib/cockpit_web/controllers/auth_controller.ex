defmodule Tankste.CockpitWeb.AuthController do
  use Tankste.CockpitWeb, :controller

  def show(conn, _params) do
    conn
    |> put_layout(html: {Tankste.CockpitWeb.Layouts, :root})
    |> render(:show)
  end

  def login(conn, %{"user" => user, "password" => password}) do
    hashed_password = :crypto.hash(:sha256, password) |> Base.encode16() |> String.downcase()

    case Map.get(logins(), user) do
      user_password when user_password == hashed_password  ->
        conn
        |> put_flash(:info, "Logged in successfully!")
        |> put_session(:current_user, user)
        |> redirect(to: ~p"/")
      _ ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: ~p"/auth")
    end
  end

  def logout(conn, _params) do
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:info, "Logged out successfully!")
    |> redirect(to: ~p"/auth")
  end

  defp logins(), do: auth_config() |> Keyword.fetch!(:logins)

  defp auth_config(), do: Application.get_env(:cockpit_web, :auth)
end
