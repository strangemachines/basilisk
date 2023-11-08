defmodule BasiliskWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :basilisk

  @cookies Application.compile_env(:basilisk, :cookies)
  @cookies_options Keyword.get(@cookies, :options, [])
  @session_options [
    store: :cookie,
    key: Keyword.get(@cookies, :session, "_key"),
    signing_salt: Application.compile_env(:basilisk, :session_salt),
    same_site: @cookies_options[:same_site],
    secure: @cookies_options[:secure]
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :basilisk,
    gzip: false,
    only: BasiliskWeb.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BasiliskWeb.Router
end
