defmodule Tankste.ReportWeb.Router do
  use Tankste.ReportWeb, :router

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

  scope "/", Tankste.ReportWeb do
    pipe_through :api

    get "/health", HealthController, :show

    resources "/reports", ReportController, only: [:index, :show, :create, :update]
  end
end
