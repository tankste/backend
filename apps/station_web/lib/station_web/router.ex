defmodule Tankste.StationWeb.Router do
  use Tankste.StationWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Tankste.StationWeb do
    pipe_through :api

    get "/health", HealthController, :show

    resources "/stations", StationController, only: [:index, :show] do
      resources "/price", StationPriceController, only: [:show], singleton: true
    end
  end
end
