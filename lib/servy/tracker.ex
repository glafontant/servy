defmodule Servy.Tracker do
  @doc """
  Simulates sending a request to an external API
  to get the GPS coordinates of a stadium in Boston.
  """
  def get_location(stadium) do
    # CODE GOES HERE TO SEND A REQUEST TO THE EXTERNAL API

    # Sleep to simulate the API delay:
    :timer.sleep(500)

    # Example responses returned from the API:
    locations = %{
      "Fenway Park"  => %{ lat: "42.3467 N", lng: "71.0972 W"},
      "TD Garden"  => %{ lat: "42.3662 N", lng: "71.0621 W"},
      "Gillette Stadium"  => %{ lat: "42.0909 N", lng: "71.2643 W"}
    }

    Map.get(locations, stadium)
  end
end
