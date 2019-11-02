defmodule Recurse do
  def sum([head | tail], total) do
    IO.puts "The sum is #{total}"
    sum(tail, total + head)
  end

  def sum([], _total), do: IO.puts "Done!"

  def triple([head | tail]) do
    [head * 3 | triple(tail)]
    IO.puts "#{head}"
  end

  def triple([]), do: IO.puts "All Done!"

  # The my_map function needs to take 2 arguments:
  # a list and a function. Recursively traverse the list,
  # calling the anonymous function with the head at each
  # step and calling itself (my_map) with the tail
  def my_map([head | tail], func) do
    [func.(head) | my_map(tail, func)]
  end

  def my_map([], _fun), do: []
end

# Recurse.sum([1, 2, 3, 4, 5], 0)
# Recurse.triple([1, 2, 3, 4, 5])