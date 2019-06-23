defmodule Servy.PatriotController do

  alias Servy.ActiveRoster
  alias Servy.Patriot
  alias Servy.PatriotView

  def index(conv) do
    patriots =
      ActiveRoster.active_players()
      |> Enum.sort(&Patriot.order_asc_by_name/2)

    %{conv | status: 200, resp_body: PatriotView.index(patriots)}
  end

  def show(conv, %{"id" => id}) do
    patriot = ActiveRoster.get_patriot(id)
    %{conv | status: 200, resp_body: PatriotView.show(patriot)}
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