defmodule SocketReply.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :socket_reply,
      version: @version,
      elixir: "~> 1.16",
      deps: deps(),
      package: package(),

      # Docs
      name: "SocketReply",
      description: "Pipe the response in LiveView functions",
      source_url: "https://github.com/sorax/socket_reply",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp docs do
    [
      main: "SocketReply",
      extras: ["README.md", "LICENSE.md"]
    ]
  end

  defp package do
    [
      maintainers: ["Robert Röske"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/sorax/socket_reply"},
      files: ~w(lib LICENSE.md mix.exs README.md)
    ]
  end
end
