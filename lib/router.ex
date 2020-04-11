defmodule Iconer.Router do
  use Plug.Router
  use Plug.Debugger

  require Logger

  plug(Plug.Logger, log: :debug)

  defp get_sets() do
    Application.get_env(:iconer, :sets, [])
    |> Enum.map(fn (%{path: path} = set) -> Map.put(set, :id, Path.basename(path)) end)
  end

  @index_template File.read!("priv/templates/index.html.eex")

  plug(:match)
  plug(:dispatch)

  get "/" do
    sets = get_sets()
    |> Enum.map(fn %{id: id, path: path} = set ->
        target_path = Path.join(path, "*.svg")
        icons = Path.wildcard(target_path)
        |> Enum.map(fn p ->
          icon = Path.basename(p)

          %{path: Path.join("/#{id}", icon), name: String.replace(icon, ".svg", "")}
        end)

        Map.put(set, :icons, icons)
    end)

    send_resp(conn, 200, EEx.eval_string(@index_template, [sets: sets]))
  end

  match "/set/:selected", via: :get do
    sets = get_sets()
    |> Enum.map(fn %{id: id, path: path} = set ->
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

    send_resp(conn, 200, EEx.eval_string(@index_template, [sets: sets]))
  end

  match "*any" do
    id? = hd(any)

    matching_set = Enum.find(get_sets(), fn set ->
      set.id == id?
    end)

    if matching_set do
      opts = Plug.Static.init([at: "/#{matching_set.id}", from: matching_set.path])
      Plug.Static.call(conn, opts)
    else
      send_resp(conn, 404, "oops")
    end
  end
end
