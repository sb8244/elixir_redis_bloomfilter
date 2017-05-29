defmodule RedisBloomfilterTest do
  use ExUnit.Case, async: false

  import Mock

  describe "insert/2" do
    test "calls RedixDriver with all options defaulted to sane values" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [insert: fn(_, _) -> {:ok, "key"} end] do
        assert RedisBloomfilter.insert("key") == {:ok, "key"}
        assert called(RedisBloomfilter.Driver.RedixDriver.insert("key", key_name: "bloom-filter", size: 100000, precision: 0.01))
      end
    end

    test "calls RedixDriver with key_name specified" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [insert: fn(_, _) -> {:ok, "key"} end] do
        RedisBloomfilter.insert("key", key_name: "test")
        assert called(RedisBloomfilter.Driver.RedixDriver.insert("key", size: 100000, precision: 0.01, key_name: "test"))
      end
    end

    test "calls RedixDriver with size specified" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [insert: fn(_, _) -> {:ok, "key"} end] do
        RedisBloomfilter.insert("key", size: 100)
        assert called(RedisBloomfilter.Driver.RedixDriver.insert("key", key_name: "bloom-filter", precision: 0.01, size: 100))
      end
    end

    test "calls RedixDriver with precision specified" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [insert: fn(_, _) -> {:ok, "key"} end] do
        RedisBloomfilter.insert("key", precision: 0.001)
        assert called(RedisBloomfilter.Driver.RedixDriver.insert("key", key_name: "bloom-filter", size: 100000, precision: 0.001))
      end
    end

    test "values from the Application config are used over defaults, if provided" do
      original = Application.get_env(RedisBloomfilter, :filter_options)
      Application.put_env(RedisBloomfilter, :filter_options, [key_name: "a", size: 1, precision: 0.5])
      with_mock RedisBloomfilter.Driver.RedixDriver, [insert: fn(_, _) -> {:ok, "key"} end] do
        assert RedisBloomfilter.insert("key") == {:ok, "key"}
        assert called(RedisBloomfilter.Driver.RedixDriver.insert("key", key_name: "a", size: 1, precision: 0.5))
      end
      Application.put_env(RedisBloomfilter, :filter_options, original)
    end

    test "values from the Application config are not used over provided values" do
      original = Application.get_env(RedisBloomfilter, :filter_options)
      Application.put_env(RedisBloomfilter, :filter_options, [key_name: "a", size: 1, precision: 0.5])
      with_mock RedisBloomfilter.Driver.RedixDriver, [insert: fn(_, _) -> {:ok, "key"} end] do
        assert RedisBloomfilter.insert("key", key_name: "provided") == {:ok, "key"}
        assert called(RedisBloomfilter.Driver.RedixDriver.insert("key", size: 1, precision: 0.5, key_name: "provided"))
      end
      Application.put_env(RedisBloomfilter, :filter_options, original)
    end
  end

  describe "include?/2" do
    test "calls RedixDriver with all options defaulted to sane values" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [include?: fn(_, _) -> true end] do
        assert RedisBloomfilter.include?("key") == true
        assert called(RedisBloomfilter.Driver.RedixDriver.include?("key", key_name: "bloom-filter", size: 100000, precision: 0.01))
      end
    end

    test "calls RedixDriver with key_name specified" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [include?: fn(_, _) -> false end] do
        assert RedisBloomfilter.include?("key", key_name: "test") == false
        assert called(RedisBloomfilter.Driver.RedixDriver.include?("key", size: 100000, precision: 0.01, key_name: "test"))
      end
    end

    test "calls RedixDriver with size specified" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [include?: fn(_, _) -> true end] do
        RedisBloomfilter.include?("key", size: 100)
        assert called(RedisBloomfilter.Driver.RedixDriver.include?("key", key_name: "bloom-filter", precision: 0.01, size: 100))
      end
    end

    test "calls RedixDriver with precision specified" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [include?: fn(_, _) -> true end] do
        RedisBloomfilter.include?("key", precision: 0.001)
        assert called(RedisBloomfilter.Driver.RedixDriver.include?("key", key_name: "bloom-filter", size: 100000, precision: 0.001))
      end
    end

    test "values from the Application config are used over defaults, if provided" do
      original = Application.get_env(RedisBloomfilter, :filter_options)
      Application.put_env(RedisBloomfilter, :filter_options, [key_name: "a", size: 1, precision: 0.5])
      with_mock RedisBloomfilter.Driver.RedixDriver, [include?: fn(_, _) -> true end] do
        assert RedisBloomfilter.include?("key") == true
        assert called(RedisBloomfilter.Driver.RedixDriver.include?("key", key_name: "a", size: 1, precision: 0.5))
      end
      Application.put_env(RedisBloomfilter, :filter_options, original)
    end

    test "values from the Application config are not used over provided values" do
      original = Application.get_env(RedisBloomfilter, :filter_options)
      Application.put_env(RedisBloomfilter, :filter_options, [key_name: "a", size: 1, precision: 0.5])
      with_mock RedisBloomfilter.Driver.RedixDriver, [include?: fn(_, _) -> true end] do
        assert RedisBloomfilter.include?("key", key_name: "provided") == true
        assert called(RedisBloomfilter.Driver.RedixDriver.include?("key", size: 1, precision: 0.5, key_name: "provided"))
      end
      Application.put_env(RedisBloomfilter, :filter_options, original)
    end
  end

  describe "clear/1" do
    test "calls RedixDriver with default key" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [clear: fn(_) -> {:ok, 2} end] do
        assert RedisBloomfilter.clear() == {:ok, 2}
        assert called(RedisBloomfilter.Driver.RedixDriver.clear(key_name: "bloom-filter"))
      end
    end

    test "values from the Application config are used over defaults, if provided" do
      original = Application.get_env(RedisBloomfilter, :filter_options)
      Application.put_env(RedisBloomfilter, :filter_options, [key_name: "a", size: 1, precision: 0.5])
      with_mock RedisBloomfilter.Driver.RedixDriver, [clear: fn(_) -> {:ok, 2} end] do
        assert RedisBloomfilter.clear() == {:ok, 2}
        assert called(RedisBloomfilter.Driver.RedixDriver.clear(key_name: "a"))
      end
      Application.put_env(RedisBloomfilter, :filter_options, original)
    end

    test "values from the Application config are not used over provided values" do
      original = Application.get_env(RedisBloomfilter, :filter_options)
      Application.put_env(RedisBloomfilter, :filter_options, [key_name: "a", size: 1, precision: 0.5])
      with_mock RedisBloomfilter.Driver.RedixDriver, [clear: fn(_) -> {:ok, 2} end] do
        assert RedisBloomfilter.clear(key_name: "provided") == {:ok, 2}
        assert called(RedisBloomfilter.Driver.RedixDriver.clear(key_name: "provided"))
      end
      Application.put_env(RedisBloomfilter, :filter_options, original)
    end
  end

  describe "initialize/0" do
    test "LUA scripts are loaded" do
      with_mock RedisBloomfilter.Driver.RedixDriver, [load_lua_scripts: fn() -> :ok end] do
        assert RedisBloomfilter.initialize() == :ok
        assert called(RedisBloomfilter.Driver.RedixDriver.load_lua_scripts())
      end
    end
  end
end
