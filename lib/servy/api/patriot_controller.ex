defmodule Servy.Api.PatriotController do

  def index(conv) do
    json = 
      Servy.ActiveRoster.active_players()
      |> Jason.encode!
    conv = put_resp_content_body(conv, "application/json")
    %{ conv | status: 200, resp_body: json }
  end

  defp put_resp_content_body(conv, content_type) do
    # update the conv map to include the new value for content type
    # then make sure override the new value for resp_headers
    headers = Map.put(conv.resp_headers, "Content-Type", content_type)
    %{ conv | resp_headers: headers}
  end    
end
