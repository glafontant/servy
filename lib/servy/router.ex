defmodule Servy.Router do

  @moduledoc "Handles routes."

  alias Servy.Conv
  alias Servy.PatriotController
  alias Servy.VideoCam

  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.FileForm, only: [handle_form: 2]

  @pages_path Path.expand("../../pages", __DIR__)

  def route(%Conv{method: "GET", path: "/snapshots"} = conv) do
    caller = self() # the request handling process

    spawn(fn -> send(caller, {:result, VideoCam.get_snapshot("cam-1")}) end)
    spawn(fn -> send(caller, {:result, VideoCam.get_snapshot("cam-2")}) end)
    spawn(fn -> send(caller, {:result, VideoCam.get_snapshot("cam-3")}) end)

    # in the caller we want to wait until the message arrives
    # from the spawned process.
    snapshot1 = receive do {:result, filename} -> filename end
    snapshot2 = receive do {:result, filename} -> filename end
    snapshot3 = receive do {:result, filename} -> filename end

    snapshots = [snapshot1, snapshot2, snapshot3]

    %{ conv | status: 200, resp_body: inspect snapshots }
  end

  # def route(%Conv{method: "GET", path: "/kaboom"} = conv) do
  #   raise "Kaboom!"
  # end

  def route(%Conv{method: "GET", path: "/recovery/" <> time} = conv) do
    time |> String.to_integer |> :timer.sleep 
    %{conv | status: 200, resp_body: "Recovered!" }
  end

  def route(%Conv{method: "GET", path: "/boston_sports_teams"} = conv) do
     %{conv | status: 200, resp_body: "Celtics, Patriots, Bruins, Red Sox" }
  end

  def route(%Conv{method: "GET", path: "/api/patriots"} = conv) do
    Servy.Api.PatriotController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/patriots"} = conv) do
    PatriotController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/patriots/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_form(conv)
  end

  def route(%Conv{method: "GET", path: "/patriots/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    PatriotController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/patriots/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    PatriotController.delete(conv, params)
  end

  def route(%Conv{method: "POST", path: "/api/patriots"} = conv) do
    Servy.Api.PatriotController.create(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/patriots"} = conv) do
    PatriotController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end
end