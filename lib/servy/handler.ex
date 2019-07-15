defmodule Servy.Handler do

   @moduledoc "Handles HTTP requests."

   import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
   import Servy.Parser, only: [parse: 1]
   import Servy.Router, only: [route: 1]
   import Servy.FormatResponse, only: [format_response: 1, put_content_length: 1]

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> put_content_length
    |> format_response
	end
end
