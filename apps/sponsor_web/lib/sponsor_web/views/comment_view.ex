defmodule Tankste.SponsorWeb.CommentView do
  use Tankste.SponsorWeb, :view

  def render("index.json", %{comments: comments}) do
    render_many(comments, Tankste.SponsorWeb.CommentView, "comment.json")
  end

  def render("show.json", %{comment: comment}) do
    render_one(comment, Tankste.SponsorWeb.CommentView, "comment.json")
  end

  def render("comment.json", %{comment: comment}) do
    %{
      "id" => comment.id,
      "name" => comment.name,
      "comment" => comment.comment,
      "value" => comment.value
    }
	end
end
