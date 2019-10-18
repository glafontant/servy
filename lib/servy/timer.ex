defmodule Servy.Timer do
  def remind(statement, interval) do
    spawn(fn ->
      :timer.sleep(interval)
      IO.puts statement
    end)
    :timer.sleep(interval)
  end
end