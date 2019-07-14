defmodule Servy.Handler do
  require Logger

   @moduledoc "Handles HTTP requests."

   import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
   import Servy.Parser, only: [parse: 1]
   import Servy.Router, only: [route: 1]
   import Servy.FormatResponse, only: [format_response: 1]

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
	end
end
