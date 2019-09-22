defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4000])

    urls = [
      "http://localhost:4000/boston_sports_teams",
      "http://localhost:4000/patriots",
      "http://localhost:4000/patriots/1",
      "http://localhost:4000/api/patriots"
    ]

    urls
    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
  end

  test "handle concurrent requests" do
    spawn(HttpServer, :start, [4000])

    parent = self()

    max_concurrent_requests = 5

    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        {:ok, response} = HTTPoison.get("http://localhost:4000/boston_sports_teams")
        send parent, {:ok, response}
      end)
    end

    for _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Celtics, Patriots, Bruins, Red Sox"
      end
    end
  end
end