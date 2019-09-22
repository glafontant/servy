defmodule Servy.Router do

  @moduledoc "Handles routes."

  alias Servy.Conv
  alias Servy.PatriotController
  alias Servy.VideoCam
  alias Servy.FourOhFourCounter, as: Counter
  alias Servy.TwoHundredCounter, as: TwoCounter

  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.FileForm, only: [handle_form: 2]
  import Servy.View, only: [render: 3]


  @pages_path Path.expand("../../pages", __DIR__)

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    task = Task.async(fn -> Servy.Tracker.get_location("Gillete Stadium") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_gilette = Task.await(task)

    render(conv, "sensors.eex", snapshots: snapshots, location: where_is_gilette)
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

  def route(%Conv{method: "GET", path: "/404s"} = conv) do
    counts = Counter.get_counts()
    %{conv | status: 200, resp_body: inspect counts }
  end

  def route(%Conv{method: "GET", path: "/200s"} = conv) do
    counts = TwoCounter.get_counts()
    %{conv | status: 200, resp_body: inspect counts}
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end
end