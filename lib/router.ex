defmodule Iconer.Router do
  use Plug.Router
  use Plug.Debugger

  require Logger

  plug(Plug.Logger, log: :debug)

  sets = Application.get_env(:iconer, :sets, [])
      |> Enum.map(fn (%{path: path, name: name} = set) -> Map.put(set, :id, Path.basename(path)) end)

  Enum.each(sets, fn %{path: path, id: id} ->
    IO.inspect("/#{id}")
    IO.inspect(path)
    plug(Plug.Static, at: "/#{id}", from: path)
  end)

  @sets sets

  plug(:match)
  plug(:dispatch)

  get "/" do
    sets = @sets
    |> Enum.map(fn %{id: id, path: path} = set ->
        target_path = Path.join(path, "*.svg")
        icons = Path.wildcard(target_path)
        |> Enum.map(fn p ->
          IO.inspect(p)
          icon = Path.basename(p) |> IO.inspect()

          Path.join("/#{id}", icon)
        end)

        Map.put(set, :icons, icons)
    end)
    send_resp(conn, 200, EEx.eval_file("lib/templates/index.html.eex", sets: sets))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
