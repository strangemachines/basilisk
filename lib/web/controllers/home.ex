defmodule BasiliskWeb.HomeHTML do
  use BasiliskWeb, :html

  embed_templates "html/*"
end

defmodule BasiliskWeb.HomeController do
  use BasiliskWeb, :controller

  alias Basilisk.{Git, Siren}

  def get_class(action) do
    if action["class"], do: List.first(action["class"]), else: "others"
  end

  def add_action(sections, action) do
    action_class = get_class(action)

    if sections[action_class] do
      section = [action | sections[action_class]]
      Map.put(sections, action_class, section)
    else
      Map.put(sections, action_class, [action])
    end
  end

  def home(conn, _params) do
    Gettext.put_locale(BasiliskWeb.Gettext, conn.cookies["locale"])

    spec = Siren.get_spec()

    sections =
      Enum.reduce(spec["actions"], %{}, fn action, acc ->
        add_action(acc, action)
      end)

    conn
    |> assign(:spec, spec)
    |> assign(:sections, sections)
    |> assign(:title, spec["properties"]["name"])
    |> assign(:version, Git.version())
    |> render(:home)
  end
end
