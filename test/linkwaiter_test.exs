defmodule LinkwaiterTest do
  use ExUnit.Case
  doctest Linkwaiter

  test "greets the world" do
    assert Linkwaiter.hello() == :world
  end
end
