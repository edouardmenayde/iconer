defmodule Iconer.Router do
  use Plug.Router
  use Plug.Debugger

  require Logger

  plug(Plug.Logger, log: :debug)

  sets = Application.get_env(:iconer, :sets, [])
      |> Enum.map(fn (%{path: path} = set) -> Map.put(set, :id, Path.basename(path)) end)

  Enum.each(sets, fn %{path: path, id: id} ->
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
          icon = Path.basename(p)

          %{path: Path.join("/#{id}", icon), name: String.replace(icon, ".svg", "")}
        end)

        Map.put(set, :icons, icons)
    end)

    send_resp(conn, 200, EEx.eval_file("lib/templates/index.html.eex", [sets: sets]))
  end

  match "/set/:selected", via: :get do
    sets = @sets
    |> Enum.map(fn %{id: id, path: path} = set ->
      IO.inspect(id)
      IO.inspect(selected)
      if selected == "" || selected == id do
        target_path = Path.join(path, "*.svg")
        icons = Path.wildcard(target_path)
        |> Enum.map(fn p ->
          icon = Path.basename(p)

          %{path: Path.join("/#{id}", icon), name: String.replace(icon, ".svg", "")}
        end)

        Map.put(set, :icons, icons)
      else
        set
      end
    end)

    send_resp(conn, 200, EEx.eval_file("lib/templates/index.html.eex", [sets: sets]))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
