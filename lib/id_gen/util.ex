defmodule IdGen.Util do
  @doc """
  Returns the current time in milliseconds
  """
  @spec current_time_millis() :: integer()
  def current_time_millis() do
    :os.system_time(:milli_seconds)
  end

  @doc """
  Returns the first interface with a valid mac address
  """
  @spec get_default_interface :: list(charlist())
  def get_default_interface do
    {:ok, network_interfaces} = :inet.getifaddrs()

    network_interfaces
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
  @spec get_hardware_interface(charlist()) :: integer()
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

  defp hardware_address_to_bytes(hardware_address) do
    <<worker_id::integer-48>> = :erlang.list_to_binary(hardware_address)
    worker_id
  end
end
