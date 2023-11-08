defmodule BasiliskWeb.HomeHTML do
  use BasiliskWeb, :html

  embed_templates "html/*"
end

defmodule BasiliskWeb.HomeController do
  use BasiliskWeb, :controller

  def home(conn, _params) do
    Gettext.put_locale(BasiliskWeb.Gettext, conn.cookies["locale"])

    render(conn, :home)
  end
end
