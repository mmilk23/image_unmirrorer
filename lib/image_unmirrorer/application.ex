# lib/image_unmirrorer/application.ex
defmodule ImageUnmirrorer.Application do
  @moduledoc """
  The main application module for ImageUnmirrorer.

  This module is responsible for starting the supervision tree of the application,
  which includes starting the Plug.Cowboy server for handling incoming HTTP requests.
  The server listens on port 4000 and serves the routes defined in the ImageUnmirrorer.Router module.
  """

  use Application

  def start(_type, _args) do
    children = [
      # Starts the Plug.Cowboy server for the routes defined in the ImageUnmirrorer.Router module
      {Plug.Cowboy, scheme: :http, plug: ImageUnmirrorer.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: ImageUnmirrorer.Supervisor]
    {:ok, sup} = Supervisor.start_link(children, opts)

    # Store the supervisor PID in the application environment for testing purposes
    Application.put_env(:image_unmirrorer, :supervisor_pid, sup)

    {:ok, sup}
  end
end
