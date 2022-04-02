defmodule RuntimeGettextPO.MixProject do
  use Mix.Project

  def project do
    [
      app: :runtime_gettext_po,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      # TODO: Split into different repos and use hex
      {:runtime_gettext, path: "../runtime_gettext"}
    ]
  end
end
