defmodule Tankste.SponsorWeb.CommentController do
  use Tankste.SponsorWeb, :controller

  alias Tankste.Sponsor.Comments
  alias Tankste.SponsorWeb.ErrorView

  def index(conn, _params) do
    comments = Comments.list()
    render(conn, "index.json", comments: comments)
  end

  def show(conn, %{"id" => device_id}) do
    case Comments.get_by_device_id(device_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json")
      comment ->
        render(conn, "show.json", comment: comment)
    end
  end

  def update(conn, %{"id" => device_id} = params) do
    case Comments.get_by_device_id(device_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json")
      comment ->
        case Comments.update(comment, %{"name" => params["name"], "comment" => params["comment"]}) do
          {:ok, comment} ->
            render(conn, "show.json", comment: comment)
          {:error, changeset} ->
            conn
            |> put_status(422)
            |> put_view(ChangesetView)
            |> render("errors.json", changeset: changeset)
        end
    end
  end
end
