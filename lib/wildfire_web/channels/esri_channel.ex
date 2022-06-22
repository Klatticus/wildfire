defmodule WildfireWeb.ESRIChannel do
  use WildfireWeb, :channel

  def join("esri:public", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("request_data", _payload, socket) do
    Wildfire.ESRIFetch.fetch_and_process()
    {:reply, {:ok, %{message: "request has been sent"}}, socket}
  end
end
