defmodule Tankste.ReportWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: Tankste.ReportWeb

      import Plug.Conn

      alias Tankste.ReportWeb.ErrorView
      alias Tankste.ReportWeb.ChangesetView
      alias Tankste.ReportWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/report_web/templates",
        namespace: Tankste.ReportWeb

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

      alias Tankste.ReportWeb.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
