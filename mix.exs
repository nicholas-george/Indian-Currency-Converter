defmodule InrWord.MixProject do
  use Mix.Project

  def project do
    [
      app: :inr_word,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      source_url: "https://github.com/nicholas-george/Indian-Currency-Converter"
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
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13", only: [:test]}
    ]
  end

  defp description() do
    "An utility to convert numbers into Indian Currency."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "inr_word",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nicholas-george/Indian-Currency-Converter"}
    ]
  end
end
