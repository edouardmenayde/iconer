defmodule Iconer do
  use Application

  @moduledoc """
  Documentation for Iconer.
  """

  def start(_type, _args) do
    port = Application.get_env(:iconer, :port, 1212)
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Iconer.Router, options: [port: port])
    ]

    IO.puts("∞ Iconer is started : http://localhost:#{port} ∞")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Iconer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
