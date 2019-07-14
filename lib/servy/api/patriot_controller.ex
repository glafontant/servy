defmodule Servy.Api.PatriotController do

  def index(conv) do
    json = 
      Servy.ActiveRoster.active_players()
      |> Jason.encode!

    %{ conv | status: 200, resp_content_type: "application/json", resp_body: json }
  end    
end
