defmodule Iconer.MixProject do
  use Mix.Project

  def project do
    [
      app: :iconer,
      version: "0.1.1-alpha",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "Iconer",
      source_url: "https://github.com/edouardmenayde/framboise"
    ]
  end

  defp description() do
    "Iconer lets you manager your svg icons without depending on any external service in a simple web interface."
  end

  defp docs do
    [
      main: "Iconer", # The main page in the docs
      extras: ["README.md"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Iconer, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.7"},
      {:plug, "~> 1.10"},
      {:plug_cowboy, "~> 2.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "priv", "README.md", "LICENSE*"],
      maintainers: ["Edouard Menayde"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/edouardmenayde/iconer"}
    ]
  end
end
