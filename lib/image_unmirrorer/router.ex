#lib\image_unmirrorer\router.ex
defmodule ImageUnmirrorer.Router do
  use Plug.Router
  require Logger

  plug :log_request

  # Logs each incoming request
  defp log_request(conn, _opts) do
    Logger.info("Handling request: #{conn.method} #{conn.request_path}")
    conn
  end

  # Function to get the image module at runtime
  defp image_module do
    Application.get_env(:image_unmirrorer, :image_module, Image)
  end

  # Serves static files from the specified directory
  plug Plug.Static,
    at: "/", # Base URL for static files
    from: {:image_unmirrorer, "priv/static"}, # Application and folder path
    gzip: false # Enable gzip in production for pre-compressed files
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug :match
  plug :dispatch

  post "/mirror" do
    Logger.debug("Processing /mirror endpoint")

    {:ok, body, conn} = Plug.Conn.read_body(conn)
    Logger.debug("Received body: #{inspect(body)}")

    # Use image_module() to fetch the module at runtime
    case image_module().from_binary(body) do
      {:ok, img} ->
        Logger.debug("Image successfully parsed")

        case image_module().flip(img, :horizontal) do
          {:ok, mirrored_img} ->
            Logger.debug("Image flipped successfully")

            case image_module().write(mirrored_img, :memory, suffix: ".jpg") do
              {:ok, mirrored_binary} ->
                Logger.debug("Image written to memory successfully")
                conn
                |> put_resp_content_type("image/jpeg")
                |> send_resp(200, mirrored_binary)

              {:error, reason} ->
                Logger.error("Failed to write image to memory: #{inspect(reason)}")
                conn
                |> put_status(:internal_server_error)
                |> put_resp_content_type("application/json")
                |> send_resp(500, Jason.encode!(%{error: "Failed to convert image to binary: #{inspect(reason)}"}))
            end

          {:error, reason} ->
            Logger.error("Failed to flip image: #{inspect(reason)}")
            conn
            |> put_status(:unprocessable_entity)
            |> put_resp_content_type("application/json")
            |> send_resp(422, Jason.encode!(%{error: "Failed to process image: #{inspect(reason)}"}))
        end

      {:error, reason} ->
        Logger.error("Failed to parse image: #{inspect(reason)}")
        conn
        |> put_status(:unprocessable_entity)
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: "Failed to process image: #{inspect(reason)}"}))
    end
  end

  # Logs when unmatched routes are accessed
  match _ do
    Logger.warning("Route not found: #{conn.method} #{conn.request_path}")
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "Not Found")
  end
end
