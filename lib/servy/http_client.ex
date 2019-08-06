defmodule Servy.HttpClient do
  def send_request(request) do
    some_host_in_net = 'localhost' #to make it runnable on one machine
    {:ok, sock} = :gen_tcp.connect(some_host_in_net, 4000, 
                                 [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(sock, request)
    {:ok, response} = :gen_tcp.recv(sock, 0)
    :ok = :gen_tcp.close(sock)
    response
  end
end

#Open up two terminal windows
# 1 for the server (need the listening server to be running)
# 1 for the client

# Servy.HttpServer.start(4000)


# request = """
# GET /api/patriots HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# \r
# """

# Servy.HttpClient.send_response(request)

