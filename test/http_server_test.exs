defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4000])

    max_concurrents = 5
    caller = self()

    for _ <- 1..max_concurrents do
      spawn(fn ->
        {:ok, response} = HTTPoison.get("localhost:4000/boston_sports_teams")
        send(caller, {:ok, response})
      end)
    end

    for _ <- 1..max_concurrents do
      receive do
        {:ok, response} ->
         assert response.status_code == 200
         assert response.body == "Celtics, Patriots, Bruins, Red Sox"
      end
    end
  end
end