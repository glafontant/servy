defmodule Servy.MixProject do
  use Mix.Project

  def project do
    [
      app: :servy,
      description: "A humble HTTP server",
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps() 
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Servy, []},
      env: [port: 3000]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"}, {:faker, "~> 0.12.0"}, {:poison, "~> 4.0"}, {:httpoison, "~> 0.12.0"}
    ]
  end
end
