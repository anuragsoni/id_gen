defmodule IdGen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: IdGen.Worker.start_link(arg)
      # {IdGen.Worker, arg},
      {IdGen.Server, %{max_time: IdGen.Util.current_time_millis(), worker_id: get_worker_id()}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IdGen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_worker_id do
    IdGen.Util.get_default_interface()
    |> IdGen.Util.get_hardware_interface()
    |> elem(1)
  end
end
