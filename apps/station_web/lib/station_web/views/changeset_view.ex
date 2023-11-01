defmodule Tankste.StationWeb.ChangesetView do
  use Tankste.StationWeb, :view

  def render("errors.json", %{changeset: changeset}) do
    %{
      "key" => "validation_error",
      "message" => "Validation error",
      "validations" => render_many(changeset.errors, Tankste.StationWeb.ChangesetView, "error.json", as: :error)
    }
  end

  def render("errors.json", %{validations: validations}) do
    %{
      "key" => "validation_error",
      "message" => "Validation error",
      "validations" => render_many(validations, Tankste.StationWeb.ChangesetView, "error.json", as: :error)
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
