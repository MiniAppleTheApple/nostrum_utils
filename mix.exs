defmodule Mark.MixProject do
  use Mix.Project

  def project do
    [
      app: :mark,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mark.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dotenv_parser, "~> 2.0"},
      {:nostrum, github: "Kraigie/nostrum"},
      {:hackney, github: "benoitc/hackney", branch: "master"},
      {:toml, "~> 0.7"},
      {:mongodb_driver, "~> 1.0.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
    ]
  end
end
