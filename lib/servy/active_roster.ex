defmodule Servy.ActiveRoster do
  alias Servy.Patriot

  def active_players do
    Path.expand("../servy/db", __DIR__)
    |> Path.join("patriots.json")
    |> read_json
    |> Poison.decode!(as: %{"patriots" => [%Patriot{}]})
    |> Map.get("patriots")
  end

  def get_patriot(id) when is_integer(id) do
    Enum.find(active_players(), fn(p) -> p.id == id end)
  end

  def get_patriot(id) when is_binary(id) do
    id |> String.to_integer |> get_patriot
  end

  defp read_json(source) do
    case File.read(source) do
      {:ok, contents} ->
        contents
      {:error, reason} -> 
        IO.inspect "Error reading #{source}: #{reason}"
        "[]"
    end
  end
end