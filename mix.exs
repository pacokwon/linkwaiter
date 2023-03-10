defmodule Linkwaiter.MixProject do
  use Mix.Project

  def project do
    [
      app: :linkwaiter,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      config_path: "config/config.exs",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Linkwaiter.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.3"},
      {:elixir_uuid, git: "https://github.com/wingyplus/elixir-uuid", branch: "extra-apps"},
    ]
  end
end
