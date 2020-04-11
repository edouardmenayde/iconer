defmodule Iconer do
  use Application

  @moduledoc """
  Documentation for Iconer.
  """

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Iconer.Router, options: [port: 1212])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Iconer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
