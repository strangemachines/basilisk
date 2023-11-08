import Config

config :basilisk, BasiliskWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "kT3tajXlY2hAnDBN6JP61B51/oAofzUFHlPoVmPosXTc29+tMy8Av4nnhXq/KYbx",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
