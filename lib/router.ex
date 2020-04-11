defmodule Iconer.Router do
  use Plug.Router
  use Plug.Debugger

  require Logger

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, EEx.eval_file("lib/templates/index.html.eex", [], []))
  end
end
