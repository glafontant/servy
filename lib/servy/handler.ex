defmodule Servy.Handler do
  
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
	end

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _] = 
      request 
      |> String.split("\n") 
      |> List.first 
      |> String.split(" ")
    %{ method: method, path: path, resp_body: ""}
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/boston_sports_teams") do
     %{ conv | resp_body: "Celtics, Patriots, Bruins, Red Sox" }
  end

  def route(conv, "GET", "/patriots") do
    %{ conv | resp_body: "Kraft, Belichik, Brady" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /boston_sports_teams HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /arsenal HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response