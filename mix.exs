defmodule Botiful.MixProject do
  use Mix.Project

  def project do
    [
      app: :botiful,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: applications(Mix.env),
      mod: {Botiful.Application, []}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:cowboy, :plug, :logger]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}

      # Web Requests
      {:cowboy, "~> 2.5.0"},
      {:plug, "~> 1.6"},
      {:plug_cowboy, "~> 2.0"},
      {:browser, "~> 0.4.4"},

      # For Chroxy
      {:chroxy_client, "~> 0.3.0"},
      {:chrome_remote_interface, "~> 0.3.0"},

      #Development
      {:remix, "~> 0.0.2", only: :dev}
    ]
  end
end
