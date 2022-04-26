defmodule Botiful.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @port 8080

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Botiful, options: [port: @port]}
      # Starts a worker by calling: Botiful.Worker.start_link(arg)
      # {Botiful.Worker, arg}
    ]

    Logger.info("Listening on #{@port}...")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Botiful.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
