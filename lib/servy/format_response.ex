defmodule Servy.FormatResponse do

  @moduledoc "Handles formatting HTTP response."

  alias Servy.Conv

  def put_content_length(%Conv{resp_headers: resp_headers} = conv) do
    add_content_length = Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body))
    %{ conv | resp_headers: add_content_length}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end

  defp format_response_headers(%Conv{resp_headers: resp_headers} = conv) do
    Enum.map(conv.resp_headers, fn {k, v} -> "#{k}: #{v}\r"
    end)
    |> Enum.sort |> Enum.reverse |> Enum.join("\n")
  end
end