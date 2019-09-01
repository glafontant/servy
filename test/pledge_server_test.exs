defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  PledgeServer.start()

  PledgeServer.create_pledge("kraft", 100)
  PledgeServer.create_pledge("henry", 200)
  PledgeServer.create_pledge("grousbeck", 300)
  PledgeServer.create_pledge("pallotta", 400)
  PledgeServer.create_pledge("mccourt", 500)

  most_recent_pledges = [ {"mccourt", 500}, {"pallotta", 400}, {"grousbeck", 300} ]

  assert PledgeServer.recent_pledges() == most_recent_pledges

  assert PledgeServer.total_pledged() == 1200
end