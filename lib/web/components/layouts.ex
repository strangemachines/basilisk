defmodule BasiliskWeb.Layouts do
  use BasiliskWeb, :html

  @app_name Application.compile_env(:basilisk, :app_name)
  @description Application.compile_env(:basilisk, :description)
  @title Application.compile_env(:basilisk, :title)

  def title(_conn, %{title: title}), do: "#{title} - #{@app_name}"

  def title(conn, _assigns) do
    if conn.request_path == "/" do
      "#{@title} - #{@app_name}"
    else
      title = String.capitalize(String.slice(conn.request_path, 1..-1))
      "#{title} - #{@app_name}"
    end
  end

  def description(%{description: description}), do: description

  def description(_assigns), do: @description

  def url(), do: BasiliskWeb.Endpoint.url()

  embed_templates "layouts/*"
end
