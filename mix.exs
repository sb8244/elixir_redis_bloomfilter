defmodule RedisBloomfilter.Mixfile do
  use Mix.Project

  def project do
    [app: :redis_bloomfilter,
     version: "0.1.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps(),
     name: "Redis Bloomfilter",
     source_url: "https://github.com/sb8244/elixir_redis_bloomfilter"]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:redix, ">= 0.0.0", only: :test},
      {:mock, "~> 0.2.0", only: :test},
    ]
  end

  defp description do
    """
    A distributed bloom filter implementation based on Redis. Uses Erik Dubbelboer's LUA scripts for the bloom filter implementation.
    """
  end

  defp package do
    [
      name: :redis_bloomfilter,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Stephen Bussey"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sb8244/elixir_redis_bloomfilter"}
    ]
  end
end
