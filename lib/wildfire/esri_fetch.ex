defmodule Wildfire.ESRIFetch do
  def fetch_and_process do
    WildfireWeb.Endpoint.broadcast("esri:public", "new_data", %{data: :erlang.system_time()})
  end
end