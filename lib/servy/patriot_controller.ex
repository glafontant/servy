defmodule Servy.PatriotController do

  alias Servy.ActiveRoster
  alias Servy.Patriot

  defp patriot_item(patriot) do
    "<li>#{patriot.name} - #{patriot.type}</li>"
  end
  
  def index(conv) do
    items = 
      ActiveRoster.active_players()
      |> Enum.filter(&Patriot.is_safety/1)
      |> Enum.sort(&Patriot.order_asc_by_name/2)
      |> Enum.map(&patriot_item/1)
      |> Enum.join

    %{conv | status: 200, resp_body: "<ul><li>#{items}</li></ul>" }
  end

  def show(conv, %{"id" => id}) do
    patriot = ActiveRoster.get_patriot(id)
    %{conv | status: 200, resp_body: "<h1>Patriot #{patriot.id}: #{patriot.name}</h1>"}
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{conv | status: 201,
             resp_body: "Created a new Patriot: #{name}, position: #{type}!"}
  end

  def delete(conv, %{"id" => id}) do
    patriot = ActiveRoster.get_patriot(id)
    %{conv | status: 200, resp_body: "<h1>Patriot #{patriot.id}: #{patriot.name} was cut!</h1>"}
  end
end