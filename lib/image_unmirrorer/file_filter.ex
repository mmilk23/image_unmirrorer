#lib\image_unmirrorer\file_filter.ex
defmodule ImageUnmirrorer.FileFilter do
  @moduledoc """
  Implements a Plug to filter incoming requests based on allowed file extensions and specific filenames.

  This module is used to ensure that only specific files and types of content are served by the application.
  It restricts access to unauthorized paths by responding with a "Forbidden" status.
  """

  import Plug.Conn

  @allowed_extensions ~w(.html .css .json .js)
  @allowed_files ~w(favicon.ico testmirror.html) # Arquivos específicos permitidos

  def init(opts), do: opts

  def call(conn, _opts) do
    path = conn.request_path

    if allowed_file?(path) do
      conn
    else
      conn
      |> send_resp(403, "Forbidden")
      |> halt()
    end
  end

  defp allowed_file?(path) do
    Enum.any?(@allowed_extensions, fn ext -> String.ends_with?(path, ext) end) or
      Enum.any?(@allowed_files, fn file -> String.ends_with?(path, file) end)
  end
end
