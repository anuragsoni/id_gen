defmodule IdGen.Server do
  use GenServer

  @me __MODULE__

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: @me)
  end

  def get_id do
    GenServer.call(@me, :generate_id)
  end

  def get_id(:url_encoded) do
    GenServer.call(@me, :generate_url_encoded)
  end

  # GenServer callbacks

  def init(%{worker_id: worker_id, max_time: max_time}) do
    {:ok, %{worker_id: worker_id, max_time: max_time, sequence: 0}}
  end

  def handle_call(
        :generate_id,
        _from,
        state
      ) do
    {id, new_state} = generate_id(IdGen.Util.current_time_millis(), state)
    {:reply, id, new_state}
  end

  def handle_call(
        :generate_url_encoded,
        _from,
        state
      ) do
    {id, new_state} = generate_id(IdGen.Util.current_time_millis(), state)
    {:reply, Base.url_encode64(id), new_state}
  end

  # Utilities

  # clock is same, increment sequence
  defp generate_id(
         timestamp,
         %{worker_id: worker_id, sequence: sequence, max_time: max_time} = state
       )
       when timestamp == max_time do
    seq = sequence + 1
    new_state = %{state | sequence: seq}
    {IdGen.Util.generate_id(timestamp, worker_id, seq), new_state}
  end

  defp generate_id(
         timestamp,
         %{worker_id: worker_id, max_time: max_time} = state
       )
       when timestamp > max_time do
    {IdGen.Util.generate_id(timestamp, worker_id, 0), %{state | sequence: 0, max_time: timestamp}}
  end
end
