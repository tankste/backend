defmodule Tankste.SponsorWeb.ApplePaymentTransactionDeviceView do
  use Tankste.SponsorWeb, :view

  def render("index.json", %{device: device}) do
    render_many(device, Tankste.SponsorWeb.DeviceView, "device.json")
  end

  def render("show.json", %{device: device}) do
    render_one(device, Tankste.SponsorWeb.DeviceView, "device.json")
  end
end
