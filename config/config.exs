import Config

config :basilisk, BasiliskWeb.Endpoint,
  live_view: [signing_salt: "/4NJfSji"],
  pubsub_server: Basilisk.PubSub,
  render_errors: [
    formats: [html: BasiliskWeb.ErrorHTML, json: BasiliskWeb.ErrorJSON],
    layout: false
  ],
  url: [host: "localhost"]

config :basilisk, BasiliskWeb.Gettext,
  default_locale: "en",
  locales: ~w(en)

config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :basilisk,
  api_url: "http://localhost:8000",
  app_name: "Basilisk",
  cookies: [
    options: [
      http_only: true,
      max_age: 846_000,
      secure: true,
      same_site: "Lax"
    ],
    locale: "locale",
    session: "_basilisk_key"
  ],
  description: "Documentation viewer for Siren APIs",
  environment: config_env(),
  items_per_page: 10,
  session_salt: "XdDrPN/W1kMm6iVvzdqon0XOacsb2NpV",
  support_email: "noreply@localhost",
  title: "Dev server",
  version: "0.1.0"

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
