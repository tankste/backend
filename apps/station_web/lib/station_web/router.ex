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

    resources "/origins", OriginController, only: [:index, :show]
    resources "/stations", StationController, only: [:show] do
      resources "/prices", StationPriceController, only: [:index]
      resources "/open-times", StationOpenTimeController, only: [:index]
      resources "/marker", StationMarkerController, singleton: true, only: [:show]
      resources "/price-snapshots", StationPriceSnapshotController, only: [:index]
    end
    resources "/markers", MarkerController, only: [:index]

  end
end
