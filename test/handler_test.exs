defmodule HandlerTest do
  use ExUnit.Case, async: true

  import Servy.Handler, only: [handle: 1]

  test "GET /boston_sports_teams" do
    request = """
    GET /boston_sports_teams HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 34\r
    \r
    Celtics, Patriots, Bruins, Red Sox
    """
  end

  test "GET /patriots" do
    request = """
    GET /patriots HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 482\r
    \r
    <h1>All Active Patriot Players!</h1>
    
    <ul>
      <li>Tom Brady - Quaterback</li>
      <li>Julian Edleman - Wide Receiver</li>
      <li>Rob Gronkowski - Tight End</li>
      <li>Patrick Chung - Safety</li>
      <li>Stephen Gilmore - Corner Back</li>
      <li>Kyle Van Noy - Linebacker</li>
      <li>Jason McCourty - Safety</li>
      <li>Marcus Cannon - Offensive Lineman</li>
      <li>Devin McCourty - Safety</li>
      <li>Donte Hightower - Linebacker</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /arsenal" do
    request = """
    GET /arsenal HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 17\r
    \r
    No /arsenal here!
    """
  end

  test "GET /patriots/1" do
    request = """
    GET /patriots/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 85\r
    \r
    <h1>Show Patriots Player</h1>
    <p>
    Is Tom Brady injured? <strong>false</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /patriots/3" do
    request = """
    GET /patriots?id=3 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 89\r
    \r
    <h1>Show Patriots Player</h1>
    <p>
    Is Rob Gronkowski injured? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /boston_teams" do
    request = """
    GET /boston_teams HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 34\r
    \r
    Celtics, Patriots, Bruins, Red Sox
    """
  end

  test "GET /pages" do
    request = """
    GET /pages/about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 388\r
    \r
    <h1>Title-Town USA</h1>

    <blockquote>
    This server is dedicated to serving all Massholes the latest and greatest
    about all Boston sports. The number one destination for all things
    Tom Brady, Bill Russel, Ted Williams, Larry Bird, Cam Neely,
    Big Papi, Pedro, Gronk, Pierce, and of course Bill Belichik.
    Boston is the greatest sports city evah!!!!
    -- Boston Strong
    </blockquote> 
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /patriots" do
    request = """
    POST /patriots HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=N\'Keal\sHarry&type=Wide\sReceiver
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 61\r
    \r
    Created a new Patriot: N'Keal Harry, position: Wide Receiver!
    """
  end

  test "DELETE /patriots" do
    request = """
    DELETE /patriots/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 38\r
    \r
    <h1>Patriot 1: Tom Brady was cut!</h1>
    """
  end

  test "GET /api/patriots" do
    request = """
    GET /api/patriots HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 760\r
    \r
    [{"type":"Quaterback","name":"Tom Brady","injured_reserve":false,"id":1},
    {"type":"Wide Receiver","name":"Julian Edleman","injured_reserve":false,"id":2},
    {"type":"Tight End","name":"Rob Gronkowski","injured_reserve":true,"id":3},
    {"type":"Safety","name":"Patrick Chung","injured_reserve":true,"id":4},
    {"type":"Corner Back","name":"Stephen Gilmore","injured_reserve":false,"id":5},
    {"type":"Linebacker","name":"Kyle Van Noy","injured_reserve":false,"id":6},
    {"type":"Safety","name":"Jason McCourty","injured_reserve":true,"id":7},
    {"type":"Offensive Lineman","name":"Marcus Cannon","injured_reserve":false,"id":8},
    {"type":"Safety","name":"Devin McCourty","injured_reserve":false,"id":9},
    {"type":"Linebacker","name":"Donte Hightower","injured_reserve":false,"id":10}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end


  test "POST /api/patriots" do
    request = """
    POST /api/patriots HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "N'Keal Harry", "type": "Wide Receiver"}
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 61\r
    \r
    Created a new Patriot: N'Keal Harry, position: Wide Receiver!
    """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
