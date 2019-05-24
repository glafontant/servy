defmodule Servy.FileForm do
  @moduledoc "Handles form."
  def handle_form({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_form({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File Not Found!"}
  end

  def handle_form({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File Error #{reason}"}
  end
end