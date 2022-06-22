defmodule Wildfire.ESRIRepeat do
  use GenServer

  def start_link(initial_args) do
    GenServer.start_link(__MODULE__, initial_args, name: __MODULE__)
  end

  def init(initial_args) do
    schedule_fetch()
    {:ok, initial_args}
  end

  def handle_info(:fetch_data, state) do
    schedule_fetch()
    Wildfire.ESRIFetch.fetch_and_process()
    {:noreply, state}
  end

  # Set the fetch interval to 1 minute
  defp schedule_fetch do
    Process.send_after(self(), :fetch_data, 60_000)
  end
end