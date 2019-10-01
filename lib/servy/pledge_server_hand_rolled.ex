defmodule Servy.GenericServer do
  def start(callback_module, initial_state \\ [], process_name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, process_name)
    pid
  end

  def call(pid, message) do
    send pid, {:call, self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)
      {:cast, message} -> 
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)
      unexpected -> 
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servy.PledgeServerHandRolled do

  @process_name __MODULE__

  alias Servy.GenericServer

  # Client Inteface Functions

  def start do
    IO.puts "Starting the Pledge Server..."
    GenericServer.start(__MODULE__, @process_name)
  end

  def create_pledge(name, amount) do
   GenericServer.call @process_name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenericServer.call @process_name, :recent_pledges
  end


  def total_pledged do
    GenericServer.call @process_name, :total_pledged
  end

  def clear do
    GenericServer.cast @process_name, :clear
  end

  # Server Callbacks

  def handle_cast(:clear, _state) do
    []
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_external_service(name, amount)
    most_recent_pleges = Enum.take(state, 2)
    new_state = [ {name, amount} | most_recent_pleges ]
    {id, new_state}
  end


  defp send_pledge_to_external_service(_name, _amount) do
    # Codes goes here to send pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServerHandRolled

# pid = PledgeServerHandRolled.start()

# send pid, {:stop, "hammer time!"}

# IO.inspect PledgeServerHandRolled.create_pledge("kraft", 100)
# IO.inspect PledgeServerHandRolled.create_pledge("henry", 200)
# IO.inspect PledgeServerHandRolled.create_pledge("grousbeck", 300)

# IO.inspect PledgeServerHandRolled.create_pledge("pallotta", 400)

# PledgeServerHandRolled.clear()

# IO.inspect PledgeServerHandRolled.create_pledge("mccourt", 500)

# IO.inspect PledgeServerHandRolled.recent_pledges()

# IO.inspect PledgeServerHandRolled.total_pledged()

# IO.inspect Process.info(pid, :messages)