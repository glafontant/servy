defmodule Servy.PledgeServer do

  @process_name __MODULE__

  # Client Inteface Functions
  def start(initial_state \\ []) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @process_name)
    pid
  end

  # we need to do 2 things here:
  # 1) send a message to the server process
  # 2) immediately wait for a response back from that server process
  # both of these functions are synchronous
  
  def create_pledge(name, amount) do
   send @process_name, {self(), :create_pledge, name, amount}
   receive do {:response, status} -> status end
  end

  def recent_pledges do
    send @process_name, {self(), :recent_pledges}
    receive do {:response, pledges} -> pledges end
  end


  def total_pledged do
    send @process_name, {self(), :total_pledged}
    receive do {:response, total} -> total end
  end

  # Server Functions
  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_external_service(name, amount)
        most_recent_pleges = Enum.take(state, 2)
        cache = [ {name, amount} | most_recent_pleges ]
        send sender, {:response, id}
        listen_loop(cache)
      {sender, :recent_pledges} ->
        send sender, {:response, state}
        listen_loop(state)
      {sender, :total_pledged} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
        send sender, {:response, total}
        listen_loop(state)
      unexpected -> 
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end
  end

  defp send_pledge_to_external_service(_name, _amount) do
    # Codes goes here to send pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServer

# pid = PledgeServer.start()

# send pid, {:stop, "hammer time!"}

# IO.inspect PledgeServer.create_pledge("kraft", 100)
# IO.inspect PledgeServer.create_pledge("henry", 200)
# IO.inspect PledgeServer.create_pledge("grousbeck", 300)
# IO.inspect PledgeServer.create_pledge("pallotta", 400)
# IO.inspect PledgeServer.create_pledge("mccourt", 500)

# IO.inspect PledgeServer.recent_pledges()

# IO.inspect PledgeServer.total_pledged()

# IO.inspect Process.info(pid, :messages)