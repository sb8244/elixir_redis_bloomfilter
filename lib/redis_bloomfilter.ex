defmodule RedisBloomfilter do
  @moduledoc """
  RedisBloomfilter is the only entry point that is necessary for public consumption.
  """

  alias RedisBloomfilter.Driver.RedixDriver

  @default_options [key_name: "bloom-filter", size: 100000, precision: 0.01]

  @doc """
  Inserts the given key into the bloom filter.
  """
  def insert(key, opts \\ []) do
    options = options_for(opts)
    RedixDriver.insert(key, options)
  end

  @doc """
  Checks whether the given key is part of the set. This method may return false positives, but
  should never return a false negative.
  """
  def include?(key, opts \\ []) do
    options = options_for(opts)
    RedixDriver.include?(key, options)
  end

  @doc """
  Clears out the bloom filter. This operation should be called cautiously, as there is no recovery
  of the keyspace.
  """
  def clear(opts \\ []) do
    options = options_for(opts) |> Map.take([:key_name])
    RedixDriver.clear(options)
  end

  @doc """
  Adds the LUA scripts to Redis. This is idempotent and can be called safely any number of times.
  """
  def initialize() do
    RedixDriver.load_lua_scripts()
  end

  defp options_for(opts) do
    @default_options |> Keyword.merge(get_application_options()) |> Keyword.merge(opts) |> Enum.into(%{})
  end

  defp get_application_options do
    Application.get_env(RedisBloomfilter, :filter_options, []) || []
  end
end
