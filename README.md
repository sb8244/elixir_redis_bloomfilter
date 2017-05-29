# Elixir Redis Bloomfilter

A distributed bloom filter implementation based on Redis. Uses [Erik Dubbelboer's] (https://github.com/erikdubbelboer)
[LUA Redis scripts](https://github.com/ErikDubbelboer/redis-lua-scaling-bloom-filter) for the bloom filter implementation.

## Installation

Add `redis_bloomfilter` to your list of dependencies in `mix.exs`,
and start its application:

```elixir
    def deps do
      [{:redis_bloomfilter, "~> 0.1.0"}]
    end
```

Note that the latest hex version may be higher than what is listed here. You can
find the latest version on [hex](https://hex.pm/packages/redis_bloomfilter). You should match
the version or alternatively you can use a looser version constraint like `"~> 1.0"`.

## Dependencies

* Redix - Requires that you have setup [Redix](https://hexdocs.pm/redix/real-world-usage.html) on your own and can provide
          a name function to the library.

## Configuration

Options to RedisBloomfilter take the following options:

* key_name  - The key prefix that will be used in redis to store the bloom filter. A single bloom filter will
              use multiple keys due to the scaling implementation.
              Default: *bloom-filter*

* size      - The initial size of the number of elements. The bloom filter will scale to any number of elements, but
              will use more keys in redis.
              Default: *100000*

* precision - The approximate precision of the bloom filter. This should be a ratio within the range (0,1)
              Default: *0.01*

The options can be passed into RedisBloomfilter functions, or set in the Application config like so:

```
config RedisBloomfilter,
  filter_options: [key_name: "custom-key", size: 1000, precision: 0.005],
```

## Redix Setup

This library assumes that you're using Redix, but doesn't necessarily require it (no mix deps). You do need a module
called Redix that responds to the Redix.command interface, and the easiest way to get that is to use Redix. So that this
library does not need OTP setup, the PID of your Redix process is done via a name. This name defaults to `:redix` but is
customizable via the `pid_fn` Application env option `pid_fn`:

```
config RedisBloomfilter,
  pid_fn: fn() ->
      id = rem(System.unique_integer([:positive]), 5)
      :"redix_#{id}"
    end
```

In the above function, a random integer [0,4] is appended to `redix_`. This comes from their
[recommended setup guide](https://hexdocs.pm/redix/real-world-usage.html).
