defmodule IdGen.Util do
  @doc ~S"""
  Returns the current time in milliseconds

  ## Examples

      iex> time = IdGen.Util.current_time_millis
      iex> time > 0
      true
  """
  @spec current_time_millis() :: integer()
  def current_time_millis() do
    System.system_time(:millisecond)
  end

  @doc """
  Returns the first interface with a valid mac address
  """
  @spec get_default_interface :: charlist()
  def get_default_interface do
    :inet.getifaddrs()
    |> elem(1)
    |> extract_interface
  end

  @doc ~S"""
  Returns the first interface from the given list,
  that has a valid mac address

  ## Examples

      iex> IdGen.Util.extract_interface([])
      []

      iex> IdGen.Util.extract_interface([{'qe1', [hwaddr: [10, 1, 9, 12, 11, 46]]}])
      'qe1'
  """
  @spec extract_interface(list()) :: charlist()
  def extract_interface([]), do: []

  def extract_interface(interfaces) do
    interfaces
    |> Stream.filter(fn {_, details} -> filter_interface(details) end)
    |> Stream.map(fn {i, _} -> i end)
    |> Enum.take(1)
    |> List.first()
  end

  defp filter_interface(details) do
    details[:hwaddr]
    |> filter_hardware_address
  end

  # exclude undefined mac address
  defp filter_hardware_address(nil), do: false
  # exclude null mac address
  defp filter_hardware_address([0, 0, 0, 0, 0, 0]), do: false
  # every other mac address is valid
  defp filter_hardware_address(_), do: true

  @doc """
  Return the mac address of given interface as a 48 bit integer
  """
  @spec get_hardware_interface(charlist()) :: integer() | {:error, :not_found}
  def get_hardware_interface([]), do: {:error, :not_found}

  def get_hardware_interface(name) do
    {:ok, interfaces} = :inet.getifaddrs()
    interface_details = :proplists.get_value(name, interfaces)

    case interface_details do
      :undefined ->
        {:error, :not_found}

      _ ->
        hardware_address = Keyword.get(interface_details, :hwaddr)
        {:ok, hardware_address_to_bytes(hardware_address)}
    end
  end

  @doc ~S"""
  Converts mac address to binary

  Examples:

      iex> IdGen.Util.hardware_address_to_bytes([1,2,3,4,5,6])
      1108152157446
  """
  @spec hardware_address_to_bytes(list(integer())) :: non_neg_integer()
  def hardware_address_to_bytes(hardware_address) do
    <<worker_id::integer-48>> = :erlang.list_to_binary(hardware_address)
    worker_id
  end

  @doc ~S"""
  Generates an ID from 64 bit timestamp + 48 bit worker id
  and 16 bit sequence.

  ## Examples

      iex> IdGen.Util.generate_id(1516071066587, 242618484254530, 12) |> Base.url_encode64
      "AAABYPzgm9vcqQSR50IADA=="
  """
  @spec generate_id(integer(), integer(), integer()) :: binary()
  def generate_id(timestamp, worker, sequence) do
    <<timestamp::integer-64, worker::integer-48, sequence::integer-16>>
  end
end
