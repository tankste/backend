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
    post "/play-payments", PlayPaymentController, :notify
    post "/apple-payments", ApplePaymentController, :notify

    resources "/balance", BalanceController, singleton: true, only: [:show]
    resources "/purchases", PurchaseController, only: [:create]
    resources "/comments", CommentController, only: [:index, :show, :update]
    resources "/sponsorships", SponsorshipController, only: [:show]

  end
end
