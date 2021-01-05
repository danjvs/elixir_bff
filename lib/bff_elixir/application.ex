defmodule BffElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      # Start the Telemetry supervisor
      BffElixirWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BffElixir.PubSub},
      # Start the Endpoint (http/h,ttps)
      BffElixirWeb.Endpoint,
      # Start a worker by calling: BffElixir.Worker.start_link(arg)
      # {BffElixir.Worker, arg}
      worker(Mongo, [[name: :mongo, url: "mongodb://localhost:27017/dan", pool_size: 10]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BffElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BffElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
