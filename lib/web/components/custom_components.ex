defmodule BasiliskWeb.CustomComponents do
  use Phoenix.Component

  alias Basilisk.Siren

  def action_name(assigns) do
    ~H"""
    <div class="action-name mt-0.5">
      <%= @action["method"] %> /<%= String.split(@action["href"], "/", parts: 4) |> List.last() %>
    </div>
    """
  end

  def action_fields(assigns) do
    ~H"""
    <ul>
      <li :for={field <- @action["fields"]}>
        <%= field["name"] %>
        <%= field["type"] %>
        <%= field["class"] %>
      </li>
    </ul>
    """
  end

  def action_example(assigns) do
    ~H"""
    <div :if={@action["fields"]} class="action-payload">
      <pre class="bg-gray-100 whitespace-pre-line my-2 p-2.5">
        <code class="code json text-sm"><%= Phoenix.HTML.raw(Siren.json_example(@action["fields"])) %></code>
      </pre>
    </div>
    """
  end
end
