defmodule ElixirRedisBloomfilter do
  @moduledoc """
  Documentation for ElixirRedisBloomfilter.
  """

  @doc """
  Inserts the given key into the bloom filter.
  """
  def insert(key) do
  end

  @doc """
  Checks whether the given key is part of the set. This method may return false positives, but
  should never return a false negative.
  """
  def include?(key) do
  end

  @doc """
  Clears out the bloom filter.
  """
  def clear do
  end
end
