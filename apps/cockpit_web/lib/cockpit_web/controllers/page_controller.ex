defmodule Tankste.CockpitWeb.PageController do
  use Tankste.CockpitWeb, :controller

  import Tankste.CockpitWeb.AuthPlug

  plug :load_current_user
  plug :require_current_user

  def home(conn, _params) do
    render(conn, :home)
  end
end
