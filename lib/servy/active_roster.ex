defmodule Servy.ActiveRoster do
  alias Servy.Patriot

  def active_players do
    [
      %Patriot{id: 1, name: "Tom Brady", type: "Quaterback"},
      %Patriot{id: 2, name: "Julian Edleman", type: "Wide Receiver"},
      %Patriot{id: 3, name: "Rob Gronkowski", type: "Tight End", injured_reserve: true},
      %Patriot{id: 4, name: "Patrick Chung", type: "Safety", injured_reserve: true},
      %Patriot{id: 5, name: "Stephen Gilmore", type: "Corner Back"},      
      %Patriot{id: 6, name: "Kyle Van Noy", type: "Linebacker"},
      %Patriot{id: 7, name: "Jason McCourty", type: "Safety", injured_reserve: true},
      %Patriot{id: 8, name: "Marcus Cannon", type: "Offensive Linesman"},
      %Patriot{id: 9, name: "Devin McCourty", type: "Safety"},
      %Patriot{id: 10, name: "Donte Hightower", type: "Linebacker"}
    ]
  end

  def get_patriot(id) when is_integer(id) do
    Enum.find(active_players(), fn(p) -> p.id == id end)
  end

  def get_patriot(id) when is_binary(id) do
    id |> String.to_integer |> get_patriot
  end
end