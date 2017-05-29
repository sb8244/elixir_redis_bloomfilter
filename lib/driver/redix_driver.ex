defmodule RedisBloomfilter.Driver.RedixDriver do
  @moduledoc """
  Interfaces with redis through Redix. Utilizes LUA scripts to do all of the bloom filter implementation.
  """

  alias RedisBloomfilter.Util.LuaScripts

  @count_prefix 0
  @entries 1000000
  @precision 0.01

  def insert(key) do
    Redix.command(get_redis_pid(), ["EVALSHA", LuaScripts.add_script_sha(), 0, @count_prefix, @entries, @precision, key])
      |> case do
        {:ok, _} -> {:ok, key}
      end
  end

  def include?(key) do
    Redix.command(get_redis_pid(), ["EVALSHA", LuaScripts.check_script_sha(), 0, @count_prefix, @entries, @precision, key])
      |> case do
        {:ok, 0} -> false
        {:ok, 1} -> true
      end
  end

  def load_lua_scripts do
    add_sha = case Redix.command(get_redis_pid(), ["SCRIPT", "LOAD", LuaScripts.add_lua_script()]) do
      {:ok, sha} -> sha
    end

    check_sha = case Redix.command(get_redis_pid(), ["SCRIPT", "LOAD", LuaScripts.check_lua_script()]) do
      {:ok, sha} -> sha
    end

    %{
      add_sha: add_sha,
      check_sha: check_sha
    }
  end

  defp get_redis_pid() do
    Application.get_env(:redis_bloomfilter, :pid_fn, &default_pid_fn/0).()
  end

  defp default_pid_fn(), do: :redix
end
