defmodule Reply.MixProject do
  use Mix.Project

  @version "1.2.1"

  def project do
    [
      app: :reply,
      version: @version,
      elixir: "~> 1.15",
      deps: deps(),
      package: package(),

      # Docs
      name: "Reply",
      description: "Pipe the response of LiveViews and GenServers",
      source_url: "https://github.com/sorax/reply",
      docs: docs()
    ]
  end

  defp deps do
    [
      {:igniter, "~> 0.6", optional: true},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false},
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
      links: %{GitHub: "https://github.com/sorax/reply"},
      files: ~w(lib LICENSE.md mix.exs README.md usage-rules.md)
    ]
  end
end
