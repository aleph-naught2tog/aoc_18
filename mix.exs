defmodule ElixirAdvent.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_advent,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [
        main_module: ElixirAdvent,
        path: "./bin/advent",
        name: "advent"
      ],
      default_task: "runner"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {
      #   :painter,
      #   git: "https://github.com/aleph-naught2tog/painter.git"
      # }
    ]
  end
end

