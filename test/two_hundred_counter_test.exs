defmodule TwoHundredCounterTest do
  use ExUnit.Case

  alias Servy.TwoHundredCounter, as: TwoCounter

  test "count the number of two hundred responses" do
    TwoCounter.start()

    TwoCounter.bump_count("/patriots")
    TwoCounter.bump_count("/boston_sports_teams")
    TwoCounter.bump_count("/patriots")
    TwoCounter.bump_count("/boston_sports_teams")
    TwoCounter.bump_count("/api/patriots")

    assert TwoCounter.get_count("/patriots") == 2
    assert TwoCounter.get_count("/boston_sports_teams") == 2
    assert TwoCounter.get_count("/api/patriots") == 1

    assert TwoCounter.get_counts == %{"/patriots" => 2, "/boston_sports_teams" => 2, "/api/patriots" => 1}
  end
end