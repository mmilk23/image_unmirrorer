# .\mix.exs
defmodule ImageUnmirrorer.MixProject do
  use Mix.Project

  def project do
    [
      app: :image_unmirrorer,
      version: "0.1.1",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.cobertura": :test,
        "coveralls.json": :test,
        "coveralls.github": :test
      ]
    ]
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
      {:plug, "~> 1.16"},
      {:plug_cowboy, "~> 2.7"},
      {:image, "~> 0.57"},
      {:jason, "~> 1.4"},
      {:open_api_spex, "~> 3.21"},
      {:excoveralls, "~> 0.18.5", only: [:test], runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:junit_formatter, "~> 3.4", only: :test, runtime: false}
    ]
  end
end
