# test\image_unmirrorer\file_filter_test.exs
defmodule ImageUnmirrorer.FileFilterTest do
  use ExUnit.Case, async: true
  import Plug.Test  # Importa conn/2 e outras funções úteis para testes de plugs

  alias ImageUnmirrorer.FileFilter

  test "allows requests with valid extensions" do
    conn = conn(:get, "/file.html")
    conn = FileFilter.call(conn, [])

    assert conn.halted == false
  end

  test "blocks requests with invalid extensions" do
    conn = conn(:get, "/file.exe")
    conn = FileFilter.call(conn, [])

    assert conn.halted == true
    assert conn.status == 403
  end

  test "allows requests for specific allowed files" do
    conn = conn(:get, "/favicon.ico")
    conn = FileFilter.call(conn, [])

    assert conn.halted == false
  end

  test "init function returns the given options" do
    opts = [some_option: "value"]
    assert FileFilter.init(opts) == opts
  end

end
