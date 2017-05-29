defmodule RedisBloomfilter do
  @moduledoc """
  RedisBloomfilter is the only entry point that is necessary for public consumption.
  """

  alias RedisBloomfilter.Driver.RedixDriver

  @doc """
  Inserts the given key into the bloom filter.
  """
  def insert(key) do
    RedixDriver.insert(key)
  end

  @doc """
  Checks whether the given key is part of the set. This method may return false positives, but
  should never return a false negative.
  """
  def include?(key) do
    RedixDriver.include?(key)
  end

  @doc """
  Clears out the bloom filter.
  """
  def clear do
    RedixDriver.clear()
  end
end
