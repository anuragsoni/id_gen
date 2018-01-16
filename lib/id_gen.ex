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
    1..number
    |> Stream.map(fn _ -> IdGen.Server.get_id() end)
    |> Enum.to_list()
  end

  def generate_id(number, :url_encoded) do
    1..number
    |> Stream.map(fn _ -> IdGen.Server.get_id(:url_encoded) end)
    |> Enum.to_list()
  end
end
