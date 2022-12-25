defmodule Linkwaiter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Linkwaiter.Router, options: [port: 5000]}
    ]
    opts = [strategy: :one_for_one, name: Linkwaiter.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
