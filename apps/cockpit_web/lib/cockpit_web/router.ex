defmodule Tankste.CockpitWeb.Router do
  use Tankste.CockpitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Tankste.CockpitWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # scope "/", Tankste.CockpitWeb do
  #   pipe_through :api

  #   get "/health", HealthController, :show
  # end

  scope "/", Tankste.CockpitWeb do
    pipe_through :browser

    get "/", PageController, :home

    get "/auth", AuthController, :show
    post "/auth/login", AuthController, :login
    get "/auth/logout", AuthController, :logout

    resources "/stations", StationController, only: [:index, :show, :new, :create, :edit, :update]
    resources "/reports", ReportController, only: [:index, :show, :edit, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Tankste.CockpitWeb do
  #   pipe_through :api
  # end
end
