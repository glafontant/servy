defmodule Servy.FourOhFourCounter do

  @name __MODULE__

  use GenServer

  ### Client

  def start_link(_arg) do
    IO.puts "Starting the FourOhFourCounter..."
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def bump_count(path) do
    GenServer.call @name, {:bump_count, path}
  end

  def get_count(path) do
    GenServer.call @name, {:get_count, path}
  end

  def get_counts do
    GenServer.call @name, :get_counts
  end

  def clear do
    GenServer.cast @name, :clear
  end

  # Server Callbacks

  def handle_cast(:clear, _state) do
    {:noreply, %{}}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_count, path}, _from, state) do
    count = Map.get(state, path, 0)
    {:reply, count, state}
  end

  def handle_call({:bump_count, path}, _from, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    {:reply, :ok, new_state}
  end
end