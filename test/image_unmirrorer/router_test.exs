#test\image_unmirrorer\router_test.exs

defmodule ImageUnmirrorer.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Plug.Conn
  import Mox

  alias ImageUnmirrorer.Router
  alias ImageMock, as: Image

  @opts Router.init([])

  setup :set_mox_from_context
  setup :verify_on_exit!

  test "POST /mirror with valid image" do
    valid_image = <<255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 0, 0, 0, 255, 217>>

    Image
    |> expect(:from_binary, fn ^valid_image -> {:ok, :mock_image} end)
    |> expect(:flip, fn :mock_image, :horizontal -> {:ok, :flipped_image} end)
    |> expect(:write, fn :flipped_image, :memory, _ -> {:ok, "mirrored_binary"} end)

    conn =
      conn(:post, "/mirror", valid_image)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 200
    assert List.first(Plug.Conn.get_resp_header(conn, "content-type")) |> String.starts_with?("image/jpeg")
    assert conn.resp_body == "mirrored_binary"
  end

  test "POST /mirror with invalid image" do
    invalid_image = "invalid_image_data"

    Image
    |> expect(:from_binary, fn ^invalid_image -> {:error, "Failed to find load buffer"} end)

    conn =
      conn(:post, "/mirror", invalid_image)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 422
    assert List.first(Plug.Conn.get_resp_header(conn, "content-type")) |> String.starts_with?("application/json")
    assert String.contains?(Jason.decode!(conn.resp_body)["error"], "Failed to process image")
  end

  test "POST /mirror with error during flip" do
    valid_image = <<255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 0, 0, 0, 255, 217>>

    Image
    |> expect(:from_binary, fn ^valid_image -> {:ok, :mock_image} end)
    |> expect(:flip, fn :mock_image, :horizontal -> {:error, :flip_failed} end)

    conn =
      conn(:post, "/mirror", valid_image)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 422
    assert List.first(Plug.Conn.get_resp_header(conn, "content-type")) |> String.starts_with?("application/json")
    assert String.contains?(Jason.decode!(conn.resp_body)["error"], "Failed to process image")
  end

  test "POST /mirror with error during image write" do
    valid_image = <<255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 0, 0, 0, 255, 217>>

    Image
    |> expect(:from_binary, fn ^valid_image -> {:ok, :mock_image} end)
    |> expect(:flip, fn :mock_image, :horizontal -> {:ok, :flipped_image} end)
    |> expect(:write, fn :flipped_image, :memory, _ -> {:error, :write_failed} end)

    conn =
      conn(:post, "/mirror", valid_image)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 500
    assert List.first(Plug.Conn.get_resp_header(conn, "content-type")) |> String.starts_with?("application/json")
    assert String.contains?(Jason.decode!(conn.resp_body)["error"], "Failed to convert image to binary: :write_failed")
  end

  test "GET /unknown route" do
    conn =
      conn(:get, "/unknown")
      |> Router.call(@opts)

    assert conn.status == 404
    assert Plug.Conn.get_resp_header(conn, "content-type") == ["text/plain; charset=utf-8"]
    assert conn.resp_body == "Not Found"
  end

  test "GET static file" do
    File.write!("priv/static/test.html", "<h1>Static File</h1>")

    conn =
      conn(:get, "/test.html")
      |> Router.call(@opts)

    assert conn.status == 200
    assert Plug.Conn.get_resp_header(conn, "content-type") == ["text/html"]
    assert conn.resp_body == "<h1>Static File</h1>"

    File.rm!("priv/static/test.html")
  end

  test "GET /unsupported route" do
    conn =
      conn(:get, "/unsupported.file")
      |> Router.call(@opts)

    assert conn.status == 404
    assert conn.resp_body == "Not Found"
  end

  test "GET non-existent static file" do
    conn =
      conn(:get, "/non_existent.html")
      |> Router.call(@opts)

    assert conn.status == 404
    assert Plug.Conn.get_resp_header(conn, "content-type") == ["text/plain; charset=utf-8"]
    assert conn.resp_body == "Not Found"
  end

end
