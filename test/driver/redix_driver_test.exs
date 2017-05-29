defmodule RedisBloomfilter.Driver.RedixDriverTest do
  use ExUnit.Case, async: false

  alias RedisBloomfilter.Driver.RedixDriver

  setup do
    {:ok, redix_pid} = Redix.start_link("redis://localhost:6379", name: :redix)
    {:ok, redix: redix_pid}
  end

  describe "load_lua_scripts" do
    test "the correct SHAs are returned from Redis" do
      assert RedixDriver.load_lua_scripts() == %{
        add_sha: "972697f22fb62b3579210b2c73a0c1eff582b7c1",
        check_sha: "1b69ae9a31e23aa614977f5bfd16683628a15847",
      }
    end

    test "the SHAs are hardcoded correctly" do
      assert RedixDriver.load_lua_scripts() == %{
        add_sha: RedisBloomfilter.Util.LuaScripts.add_script_sha,
        check_sha: RedisBloomfilter.Util.LuaScripts.check_script_sha,
      }
    end
  end

  describe "insert/2" do
    test "returns {:ok, key}" do
      assert RedixDriver.insert("key", key_name: "rbf-d-test", size: 100, precision: 0.01) == {:ok, "key"}
    end
  end

  describe "include?/2" do
    test "returns false for a key not in the set" do
      assert RedixDriver.include?("never, nope", key_name: "rbf-d-test", size: 100, precision: 0.01) == false
    end

    test "it returns false for a bunch of keys not in the set" do
      Enum.each(1..100, fn(i) ->
        assert RedixDriver.include?("never, nope #{i}", key_name: "rbf-d-test", size: 100, precision: 0.01) == false
      end)
    end

    test "it returns true (hopefully) for a key in the set" do
      assert RedixDriver.insert("key", key_name: "rbf-d-test", size: 100, precision: 0.01) == {:ok, "key"}
      assert RedixDriver.include?("key", key_name: "rbf-d-test", size: 100, precision: 0.01) == true
    end
  end
end
