defmodule Servy.Handler do
  require Logger
  
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> emojify
    |> track
    |> format_response
	end

  def parse(request) do
    [method, path, _] = 
      request 
      |> String.split("\n") 
      |> List.first 
      |> String.split(" ")
    %{
        method: method,
        path: path,
        status: nil,
        resp_body: ""
      }
  end

  # We only want this to be run when we have a 404 error
  def track(%{ status: 404, path: path } = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{ path: path } = conv) do
    regex = ~r{\/(?<route>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"route" => route, "id" => id}) do
    %{ conv | path: "/#{route}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv

  def log(conv), do: IO.inspect conv

  def route(%{method: "GET", path: "/boston_sports_teams"} = conv) do
     %{ conv | status: 200, resp_body: "Celtics, Patriots, Bruins, Red Sox" }
  end

  def route(%{method: "GET", path: "/patriots"} = conv) do
    %{ conv | status: 200, resp_body: "Kraft, Belichik, Brady" }
  end

  def route(%{method: "GET", path: "/patriots/" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Patriot #{id}"}
  end

  def route(%{method: "DELETE", path: "/patriots/" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Patriot #{id} removed"}
  end

  def route(%{path: path} = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end

  def emojify(%{resp_body: resp_body, status: 200} = conv) do
    %{ conv | resp_body: resp_body <> " :D" }
  end

  def emojify(conv), do: conv

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
        200 => "OK",
        201 => "Created",
        401 => "Unauthorized",
        403 => "Forbidden",
        404 => "Not Found",
        500 => "Internal Server Error"
    }[code]
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
GET /patriots HTTP/1.1
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


request = """
GET /patriots/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
DELETE /patriots/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /boston_teams HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /patriots?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /patriots?id=2 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response