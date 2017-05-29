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
  end
end
