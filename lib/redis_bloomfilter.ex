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
    options = Keyword.merge(@default_options, opts)
    RedixDriver.insert(key, options)
  end

  @doc """
  Checks whether the given key is part of the set. This method may return false positives, but
  should never return a false negative.
  """
  def include?(key, opts \\ []) do
    options = Keyword.merge(@default_options, opts)
    RedixDriver.include?(key, options)
  end

  # @doc """
  # Clears out the bloom filter.
  # """
  # def clear do
  #   RedixDriver.clear()
  # end
end
