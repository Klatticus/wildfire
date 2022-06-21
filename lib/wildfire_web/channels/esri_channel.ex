defmodule WildfireWeb.ESRIChannel do
  use WildfireWeb, :channel

  @impl true
  def join("esri:public", _payload, socket) do
    {:ok, socket}
  end
end
