defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

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
    Content-Length: 761\r
    \r
    [{"id":1,"injured_reserve":false,"name":"Tom Brady","type":"Quaterback"},
     {"id":2,"injured_reserve":false,"name":"Julian Edleman","type":"Wide Receiver"},
     {"id":3,"injured_reserve":true,"name":"Rob Gronkowski","type":"Tight End"},
     {"id":4,"injured_reserve":true,"name":"Patrick Chung","type":"Safety"},
     {"id":5,"injured_reserve":false,"name":"Stephen Gilmore","type":"Corner Back"},
     {"id":6,"injured_reserve":false,"name":"Kyle Van Noy","type":"Linebacker"},
     {"id":7,"injured_reserve":true,"name":"Jason McCourty","type":"Safety"},
     {"id":8,"injured_reserve":false,"name":"Marcus Cannon","type":"Offensive Linesman"},
     {"id":9,"injured_reserve":false,"name":"Devin McCourty","type":"Safety"},
     {"id":10,"injured_reserve":false,"name":"Donte Hightower","type":"Linebacker"}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
