# test\image_unmirrorer\router_test.exs

defmodule ExtendedImageBehaviour do
  @moduledoc """
  Versão estendida do comportamento de imagem para testes, incluindo a função
  `to_colorspace/2` que é chamada no router.
  """
  @callback from_binary(binary()) :: {:ok, any()} | {:error, term()}
  @callback flip(any(), atom()) :: {:ok, any()} | {:error, term()}
  @callback to_colorspace(any(), atom()) :: {:ok, any()} | {:error, term()}
  @callback write(any(), atom(), keyword()) :: {:ok, binary()} | {:error, term()}
end

Mox.defmock(ImageMock, for: ExtendedImageBehaviour)

defmodule ImageUnmirrorer.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Plug.Conn
  import Mox
  import ExUnit.CaptureLog

  alias ImageUnmirrorer.Router
  alias ImageMock, as: Image

  @opts Router.init([])

  setup :set_mox_from_context
  setup :verify_on_exit!

  ## Testes para o endpoint /mirror

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
    assert List.first(get_resp_header(conn, "content-type"))
           |> String.starts_with?("image/jpeg")
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
    assert List.first(get_resp_header(conn, "content-type"))
           |> String.starts_with?("application/json")
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
    assert List.first(get_resp_header(conn, "content-type"))
           |> String.starts_with?("application/json")
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
    assert List.first(get_resp_header(conn, "content-type"))
           |> String.starts_with?("application/json")
    assert String.contains?(Jason.decode!(conn.resp_body)["error"],
           "Failed to convert image to binary: :write_failed")
  end

  test "POST /mirror without content-type header" do
    valid_image = <<255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 0, 0, 0, 255, 217>>

    # Sem header, a pipeline deve rejeitar a requisição.
    conn =
      conn(:post, "/mirror", valid_image)
      |> Router.call(@opts)

    assert conn.status == 422
  end

  test "POST /mirror with from_binary error" do
    invalid_body = "invalid"
    error_msg = "Failed to parse image in test"

    Image
    |> expect(:from_binary, fn ^invalid_body -> {:error, error_msg} end)

    conn =
      conn(:post, "/mirror", invalid_body)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 422
    assert get_resp_header(conn, "content-type") == ["application/json"]
    assert conn.resp_body == Jason.encode!(%{error: "Failed to process image: #{inspect(error_msg)}"})
  end

  ## Testes para o endpoint /grayscale

  test "POST /grayscale with valid image" do
    valid_image = <<255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 0, 0, 0, 255, 217>>

    Image
    |> expect(:from_binary, fn ^valid_image -> {:ok, :mock_image} end)
    |> expect(:to_colorspace, fn :mock_image, :bw -> {:ok, :grayscale_image} end)
    |> expect(:write, fn :grayscale_image, :memory, _ -> {:ok, "grayscale_binary"} end)

    conn =
      conn(:post, "/grayscale", valid_image)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 200
    assert conn.resp_body == "grayscale_binary"
  end

  test "POST /grayscale with error in grayscale processing" do
    valid_image = <<255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 0, 0, 0, 255, 217>>

    Image
    |> expect(:from_binary, fn ^valid_image -> {:ok, :mock_image} end)
    |> expect(:to_colorspace, fn _image, :bw -> {:error, "Grayscale conversion failed"} end)

    conn =
      conn(:post, "/grayscale", valid_image)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 422
    assert conn.resp_body =~ "Failed to process image"
  end

  test "POST /grayscale with error during image write" do
    valid_image = <<255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 0, 0, 0, 255, 217>>

    Image
    |> expect(:from_binary, fn ^valid_image -> {:ok, :mock_image} end)
    |> expect(:to_colorspace, fn :mock_image, :bw -> {:ok, :grayscale_image} end)
    |> expect(:write, fn :grayscale_image, :memory, _ -> {:error, :write_failed} end)

    conn =
      conn(:post, "/grayscale", valid_image)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 500
    assert conn.resp_body =~ "Failed to convert image to binary"
  end

  test "POST /grayscale with unexpected error" do
    valid_image = <<255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 0, 0, 0, 255, 217>>

    Image
    |> expect(:from_binary, fn _ -> raise "Unexpected error" end)

    assert_raise RuntimeError, "Unexpected error", fn ->
      conn(:post, "/grayscale", valid_image)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)
    end
  end

  test "POST /grayscale with empty body" do
    conn =
      conn(:post, "/grayscale", "")
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 422
    assert conn.resp_body =~ "Failed to process image"
  end

  test "POST /grayscale with from_binary error" do
    invalid_body = "not_an_image"
    error_msg = "parse error"

    Image
    |> expect(:from_binary, fn ^invalid_body -> {:error, error_msg} end)

    conn =
      conn(:post, "/grayscale", invalid_body)
      |> put_req_header("content-type", "image/jpeg")
      |> Router.call(@opts)

    assert conn.status == 422
    assert get_resp_header(conn, "content-type") == ["application/json"]
    # Assegure-se de comparar o JSON completo ou usar =~ se preferir
    assert conn.resp_body == Jason.encode!(%{
      error: "Failed to process image: #{inspect(error_msg)}"
    })
  end

  ## Testes para rotas GET

  test "GET /unknown route" do
    conn =
      conn(:get, "/unknown")
      |> Router.call(@opts)

    assert conn.status == 404
    assert get_resp_header(conn, "content-type") == ["text/plain; charset=utf-8"]
    assert conn.resp_body == "Not Found"
  end

  test "GET static file" do
    File.write!("priv/static/test.html", "<h1>Static File</h1>")

    conn =
      conn(:get, "/test.html")
      |> Router.call(@opts)

    assert conn.status == 200
    assert get_resp_header(conn, "content-type") == ["text/html"]
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
    assert get_resp_header(conn, "content-type") == ["text/plain; charset=utf-8"]
    assert conn.resp_body == "Not Found"
  end

  test "Logs request handling" do
    log = capture_log(fn ->
      conn(:get, "/unknown") |> Router.call(@opts)
    end)

    assert log =~ "Handling request: GET /unknown"
    assert log =~ "Route not found: GET /unknown"
  end
end
