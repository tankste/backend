defmodule Tankste.SponsorWeb.ChangesetView do
  use Tankste.SponsorWeb, :view

  def render("errors.json", %{changeset: changeset}) do
    %{
      "key" => "validation_error",
      "message" => "Validation error",
      "validations" => render_many(changeset.errors, Tankste.SponsorWeb.ChangesetView, "error.json", as: :error)
    }
  end

  def render("errors.json", %{validations: validations}) do
    %{
      "key" => "validation_error",
      "message" => "Validation error",
      "validations" => render_many(validations, Tankste.SponsorWeb.ChangesetView, "error.json", as: :error)
    }
  end

  def render("error.json", %{error: {field, {message, opts}}}) do
    %{
      "key" => key(opts),
      "field" => field,
      "message" => message
    }
  end

  defp key([{:validation, key} | _opts]), do: key

  defp key([{:constraint, key} | _opts]), do: key

  defp key(_), do: nil
end
