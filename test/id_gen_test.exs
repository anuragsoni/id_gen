defmodule IdGenTest do
  use ExUnit.Case
  doctest IdGen

  test "greets the world" do
    assert IdGen.hello() == :world
  end
end
