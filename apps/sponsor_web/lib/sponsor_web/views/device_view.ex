defmodule Tankste.SponsorWeb.DeviceView do
  use Tankste.SponsorWeb, :view

  def render("device.json", %{device: device}) do
    %{
      "id" => device.id
    }
	end
end
