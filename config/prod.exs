import Config

log_level = String.to_atom(String.downcase(System.get_env("BASILISK_LOG_LEVEL", "INFO")))

config :basilisk, BasiliskWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  http: [:inet6, port: System.get_env("BASILISK_PORT") || 4000],
  live_view: [signing_salt: System.get_env("BASILISK_SIGNING_SALT")],
  secret_key_base: System.get_env("BASILISK_SECRET_KEY_BASE"),
  url: [
    scheme: System.get_env("BASILISK_APP_SCHEME", "https"),
    host: System.get_env("BASILISK_APP_HOST"),
    port: System.get_env("BASILISK_APP_PORT", "443")
  ]

config :basilisk,
  api_url: System.get_env("BASILISK_API_URL"),
  app_name: System.get_env("BASILISK_APP_NAME"),
  cookies: [
    options: [
      max_age: String.to_integer(System.get_env("BASILISK_COOKIE_MAX_AGE"))
    ],
    locale: System.get_env("BASILISK_LOCALE_COOKIE_NAME"),
    session: System.get_env("BASILISK_SESSION_COOKIE_NAME")
  ],
  description: System.get_env("BASILISK_DESCRIPTION"),
  session_salt: System.get_env("BASILISK_SESSION_SALT"),
  support_email: System.get_env("BASILISK_SUPPORT_EMAIL"),
  title: System.get_env("BASILISK_TITLE")

config :logger,
  backends: [{LoggerFileBackend, :filelog}],
  level: log_level

config :logger, :filelog,
  format: "$date $time $metadata[$level] $message\n",
  path: System.get_env("BASILISK_LOG_FILE"),
  level: log_level,
  metadata: [:request_id]
