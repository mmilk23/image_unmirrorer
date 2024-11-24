#.\mix.exs
defmodule ImageUnmirrorer.MixProject do
  use Mix.Project

  def project do
    [
      app: :image_unmirrorer,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [
        tool: ExCoveralls
      ]    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ImageUnmirrorer, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.6"},
      {:image, "~> 0.54.4"},
      {:jason, "~> 1.4"},
      {:open_api_spex, "~> 3.21"},
      {:excoveralls, "~> 0.18", only: [:test], runtime: false},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
