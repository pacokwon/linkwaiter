defmodule Linkwaiter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    store_file_path = Application.fetch_env!(:linkwaiter, :links_json_path)
    ip = case Application.fetch_env!(:linkwaiter, :env) do
      :dev -> {0, 0, 0, 0}
      :prod -> {127, 0, 0, 1}
    end

    children = [
      {Plug.Cowboy, scheme: :http, plug: Linkwaiter.Router, options: [ip: ip, port: 5000]},
      {Linkwaiter.LinkStore, path: store_file_path},
      {Task.Supervisor, name: Linkwaiter.TaskSupervisor}
    ]
    opts = [strategy: :one_for_one, name: Linkwaiter.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
