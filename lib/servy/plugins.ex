defmodule Servy.Plugins do
  @doc "Logs 404 request"

  alias Servy.Conv

  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<route>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"route" => route, "id" => id}) do
    %{conv | path: "/#{route}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv

  def log(%Conv{} = conv), do: IO.inspect conv
end