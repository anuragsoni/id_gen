defmodule IdGen do
  @moduledoc """
  IdGen generate 128 bit, k-ordered ids
  """

  def generate_id() do
    IdGen.Server.get_id()
  end

  def generate_id(:url_encoded) do
    IdGen.Server.get_id(:url_encoded)
  end

  def generate_id(number) do
    for _ <- 1..number, do: IdGen.generate_id()
  end

  def generate_id(number, :url_encoded) do
    for _ <- 1..number, do: IdGen.generate_id(:url_encoded)
  end
end
