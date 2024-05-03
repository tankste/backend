defmodule Tankste.CockpitWeb.PageController do
  use Tankste.CockpitWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
