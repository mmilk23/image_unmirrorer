#lib\image_unmirrorer.ex
defmodule ImageUnmirrorer do
  @moduledoc """
  The main entry point for the Image Unmirrorer application.

  This module starts the application's supervision tree and sets up the HTTP server
  to handle incoming requests using the Plug.Cowboy library.
  """

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: ImageUnmirrorer.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: ImageUnmirrorer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
