defmodule Tankste.FillWeb.Router do
  use Tankste.FillWeb, :router

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

  scope "/", Tankste.FillWeb do
    pipe_through :api

    get "/health", HealthController, :show

    post "/stations", StationController, :update
    post "/prices", PriceController, :update
    post "/holidays", HolidayController, :update
  end
end
