defmodule Basilisk.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BasiliskWeb.Telemetry,
      {Phoenix.PubSub, name: Basilisk.PubSub},
      BasiliskWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Basilisk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    BasiliskWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
