defmodule Reply.MixProject do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :reply,
      version: @version,
      elixir: "~> 1.14",
      deps: deps(),
      package: package(),

      # Docs
      name: "Reply",
      description: "Pipe the response in LiveView functions",
      source_url: "https://github.com/sorax/reply",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "Reply",
      extras: ["README.md", "LICENSE.md"]
    ]
  end

  defp package do
    [
      maintainers: ["sorax"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/sorax/reply"},
      files: ~w(lib LICENSE.md mix.exs README.md)
    ]
  end
end
