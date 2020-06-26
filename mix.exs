defmodule Nwith.MixProject do
  use Mix.Project

  def project do
    [
      app: :nwith,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    "This library provides `nwith` macro for named fallbacks of `with`-like clauses."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Viktor Klymentiev"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/yondermon/nwith"
      }
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
      {:ex_doc, "~> 0.22.1", only: :dev}
    ]
  end
end
