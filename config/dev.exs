import Config

config :basilisk, BasiliskWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "kzNTNsfSkjU7pqvNKmR6+jpDgC+TozoNTxou296xmQrTO5osdjFfHZFTn0JGx9h+",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

config :basilisk, BasiliskWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :basilisk, dev_routes: true

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
