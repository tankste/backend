defmodule Tankste.SponsorWeb.ErrorView do
    use Tankste.SponsorWeb, :view

    def render("400.html", _assigns) do
      "Bad request! (400)"
    end

    def render("404.html", _assigns) do
      "Not found! (404)"
    end

    def render("500.html", _assigns) do
      "Internal server error (500)"
    end

    def render("400.json", _assigns) do
      %{
        "key" => "bad_request",
        "message" => "Bad request (400)"
      }
    end

    def render("401.json", _assigns) do
      %{
        "key" => "unauthorized",
        "message" => "Unauthorized (401)"
      }
    end

    def render("403.json", _assigns) do
      %{
        "key" => "forbidden",
        "message" => "Forbidden (403)"
      }
    end

    def render("404.json", _assigns) do
      %{
        "key" => "not_found",
        "message" => "Not found (404)"
      }
    end

    def render("500.json", _assigns) do
      %{
        "key" => "server_error",
        "message" => "Internal server error (500)"
      }
    end

    def template_not_found(_template, _assigns) do
      "Error!"
    end
  end
