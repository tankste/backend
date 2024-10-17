defmodule Tankste.SponsorWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: Tankste.SponsorWeb

      import Plug.Conn

      alias Tankste.SponsorWeb.ErrorView
      alias Tankste.SponsorWeb.ChangesetView
      alias Tankste.SponsorWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/sponsor_web/templates",
        namespace: Tankste.SponsorWeb

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
      import Phoenix.View

      alias Tankste.SponsorWeb.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
