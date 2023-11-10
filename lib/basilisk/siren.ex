defmodule Basilisk.Siren do
  use Tesla

  alias Basilisk.Siren

  @url Application.compile_env(:basilisk, :api_url)

  plug(Tesla.Middleware.BaseUrl, @url)
  plug(Tesla.Middleware.JSON, decode_content_types: ["application/vnd.siren+json"])

  def get_spec() do
    case Siren.get("/") do
      {:ok, response} -> response.body
      e -> e
    end
  end

  def example_value(field) do
    cond do
      field["type"] == "text" && Enum.member?(field["class"], "primary-key") ->
        "\"00000000-0000-0000-0000-000000000000\""

      field["type"] == "checkbox" ->
        "true"

      field["type"] == "date" ->
        "\"#{Date.to_string(Date.utc_today())}\""

      field["type"] == "email" ->
        "\"email@example.com\""

      field["type"] == "number" ->
        1

      field["type"] == "password" ->
        "\"*****\""

      true ->
        "\"value\""
    end
  end

  def json_kv(field) do
    "\"#{field["name"]}\": #{Siren.example_value(field)}"
  end

  def json_example(fields) do
    fields
    |> Enum.with_index()
    |> Enum.reduce([], fn {field, index}, acc ->
      cond do
        index == 0 && index == Enum.count(fields) - 1 ->
          ["{\n#{Siren.json_kv(field)}\n}" | acc]

        index == 0 ->
          ["{\n#{Siren.json_kv(field)}, " | acc]

        index == Enum.count(fields) - 1 ->
          ["\n#{Siren.json_kv(field)}\n}" | acc]

        true ->
          ["\n#{Siren.json_kv(field)}," | acc]
      end
    end)
    |> Enum.reverse()
    |> Enum.join()
  end
end
