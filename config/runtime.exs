import Config

if System.get_env("PHX_SERVER") do
  config :basilisk, BasiliskWeb.Endpoint, server: true
end
