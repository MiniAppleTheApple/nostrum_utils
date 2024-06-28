defmodule NostrumUtils.MixProject do
  use Mix.Project

  @scm_url "https://github.com/MiniAppleTheApple/nostrum_utils"

  def project do
    [
      app: :nostrum_utils,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      source_url: @scm_url,
      deps: deps(),
      description: "A library which provides some utilities for Nostrum, a Discord api wrapper for Elixir."
    ]
  end

  def package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @scm_url},
      maintainers: ["MiniAppleTheApple"],
      files:
        ~w(lib mix.exs README.md .formatter.exs)
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dotenv_parser, "~> 2.0"},
      {:nostrum, github: "Kraigie/nostrum"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
    ]
  end
end
