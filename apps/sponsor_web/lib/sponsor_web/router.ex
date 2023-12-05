defmodule Tankste.SponsorWeb.Router do
  use Tankste.SponsorWeb, :router

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

  scope "/", Tankste.SponsorWeb do
    pipe_through :api

    get "/health", HealthController, :show
    resources "/balance", BalanceController, singleton: true, only: [:show]
    resources "/purchases", PurchaseController, only: [:create]

    post "/play-payments", PlayPaymentController, :notify
  end
end
