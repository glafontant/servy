defmodule Servy.Router do

  @moduledoc "Handles routes."

  alias Servy.Conv

  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.FileForm, only: [handle_form: 2]

  @pages_path Path.expand("../../pages", __DIR__) 

  def route(%Conv{method: "GET", path: "/boston_sports_teams"} = conv) do
     %{conv | status: 200, resp_body: "Celtics, Patriots, Bruins, Red Sox" }
  end

  def route(%Conv{method: "GET", path: "/patriots"} = conv) do
    %{conv | status: 200, resp_body: "Kraft, Belichik, Brady" }
  end

  def route(%Conv{method: "GET", path: "/patriots/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_form(conv)
  end

  def route(%Conv{method: "GET", path: "/patriots/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Patriot #{id}"}
  end

  def route(%Conv{method: "DELETE", path: "/patriots/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Patriot #{id} removed"}
  end

  def route(%Conv{method: "POST", path: "/patriots"} = conv) do
    %{conv | status: 201, resp_body: "Created a new Patriot: #{conv.params["name"]}, position: #{conv.params["type"]}!"}
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
      Path.expand("../../pages", __DIR__)
      |> Path.join(file <> ".html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end
end