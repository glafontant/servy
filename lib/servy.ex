defmodule Servy do
  use Application

  def start(_type, _args) do
    IO.puts "Starting the Application"
    Servy.Supervisor.start_link()
  end
end