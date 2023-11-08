defmodule BasiliskWeb.Router do
  use BasiliskWeb, :router

  @gettext_config Application.compile_env(:basilisk, BasiliskWeb.Gettext)
  @default_locale Keyword.get(@gettext_config, :default_locale)

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BasiliskWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BasiliskWeb.LocalePlug, @default_locale
  end

  scope "/", BasiliskWeb do
    pipe_through :browser

    get "/", HomeController, :home
  end

  if Application.compile_env(:basilisk, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BasiliskWeb.Telemetry
    end
  end
end
