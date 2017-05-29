# Elixir Redis Bloomfilter

A distributed bloom filter implementation based on Redis. Uses [Erik Dubbelboer's] (https://github.com/erikdubbelboer)
[LUA Redis scripts](https://github.com/ErikDubbelboer/redis-lua-scaling-bloom-filter) for the bloom filter implementation.

## Dependencies

* Redix - Requires that you have setup [Redix](https://hexdocs.pm/redix/real-world-usage.html) on your own and can provide
          a name function to the library.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_redis_bloomfilter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:elixir_redis_bloomfilter, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixir_redis_bloomfilter](https://hexdocs.pm/elixir_redis_bloomfilter).
