defmodule IdGenTest do
  use ExUnit.Case

  doctest IdGen

  test "generates uniq ids" do
    ids = IdGen.generate_id(1000, :url_encoded)
    assert Enum.uniq(ids) == ids
  end
end
