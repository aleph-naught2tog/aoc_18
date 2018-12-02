defmodule ElixirAdventTest do
  use ExUnit.Case
  doctest ElixirAdvent

  test "greets the world" do
    assert ElixirAdvent.hello() == :world
  end
end
