defmodule Servy.Plugins do
  require Logger
  @doc "Logs 404 request"

  alias Servy.Conv

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      Logger.warn "Warning: #{path} is on the loose!"
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%{path: "/boston_teams"} = conv) do
    %{ conv | path: "/boston_sports_teams" }
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<route>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"route" => route, "id" => id}) do
    %{conv | path: "/#{route}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      Logger.info "#{inspect conv}"
    end
    conv
  end
end