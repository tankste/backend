defmodule Tankste.FillWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: Tankste.FillWeb

      import Plug.Conn

      alias Tankste.FillWeb.ErrorView
      alias Tankste.StationWeb.ChangesetView
      alias Tankste.StationWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/station_web/templates",
        namespace: Tankste.StationWeb

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML

      import Phoenix.View

      alias Tankste.StationWeb.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
