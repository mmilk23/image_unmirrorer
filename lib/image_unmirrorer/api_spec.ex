#lib\image_unmirrorer\api_spec.ex
defmodule ImageUnmirrorer.ApiSpec do
  @moduledoc """
  Defines the OpenAPI specification for the Image Unmirrorer API.

  This module uses OpenApiSpex to define the structure of the API, including the endpoints,
  request bodies, and responses. It helps to ensure consistent and self-documenting API behavior.
  """

  alias OpenApiSpex.{Info, Operation, OpenApi, PathItem, RequestBody, Response, Schema}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        %OpenApiSpex.Server{url: "http://localhost:4000"}
      ],
      info: %Info{
        title: "Image Unmirrorer API",
        version: "1.0.0",
        description: "API for mirroring images sent by clients."
      },
      paths: %{
        "/mirror" => %PathItem{
          post: %Operation{
            tags: ["Image Operations"],
            summary: "Mirror an image",
            description: "Receives an image and returns a horizontally flipped version of it.",
            operationId: "ImageUnmirrorer.Mirror",
            requestBody: %RequestBody{
              description: "Image to be mirrored",
              required: true,
              content: %{
                "image/jpeg" => %OpenApiSpex.MediaType{
                  schema: %Schema{
                    type: :string,
                    format: :binary
                  }
                },
                "image/png" => %OpenApiSpex.MediaType{
                  schema: %Schema{
                    type: :string,
                    format: :binary
                  }
                }
              }
            },
            responses: %{
              200 => %Response{
                description: "Mirrored image",
                content: %{
                  "image/jpeg" => %OpenApiSpex.MediaType{
                    schema: %Schema{
                      type: :string,
                      format: :binary
                    }
                  }
                }
              },
              422 => %Response{
                description: "Unprocessable Entity",
                content: %{
                  "application/json" => %OpenApiSpex.MediaType{
                    schema: %Schema{
                      type: :object,
                      properties: %{
                        error: %Schema{type: :string}
                      },
                      required: [:error]
                    }
                  }
                }
              },
              500 => %Response{
                description: "Internal Server Error",
                content: %{
                  "application/json" => %OpenApiSpex.MediaType{
                    schema: %Schema{
                      type: :object,
                      properties: %{
                        error: %Schema{type: :string}
                      },
                      required: [:error]
                    }
                  }
                }
              }
            }
          }
        },
        "/grayscale" => %PathItem{
          post: %Operation{
            tags: ["Image Operations"],
            summary: "grayscale an image",
            description: "Receives an image and returns a grayscale version of it.",
            operationId: "ImageUnmirrorer.Grayscale",
            requestBody: %RequestBody{
              description: "Image to be grayscaled",
              required: true,
              content: %{
                "image/jpeg" => %OpenApiSpex.MediaType{
                  schema: %Schema{
                    type: :string,
                    format: :binary
                  }
                },
                "image/png" => %OpenApiSpex.MediaType{
                  schema: %Schema{
                    type: :string,
                    format: :binary
                  }
                }
              }
            },
            responses: %{
              200 => %Response{
                description: "Grayscale image",
                content: %{
                  "image/jpeg" => %OpenApiSpex.MediaType{
                    schema: %Schema{
                      type: :string,
                      format: :binary
                    }
                  }
                }
              },
              422 => %Response{
                description: "Unprocessable Entity",
                content: %{
                  "application/json" => %OpenApiSpex.MediaType{
                    schema: %Schema{
                      type: :object,
                      properties: %{
                        error: %Schema{type: :string}
                      },
                      required: [:error]
                    }
                  }
                }
              },
              500 => %Response{
                description: "Internal Server Error",
                content: %{
                  "application/json" => %OpenApiSpex.MediaType{
                    schema: %Schema{
                      type: :object,
                      properties: %{
                        error: %Schema{type: :string}
                      },
                      required: [:error]
                    }
                  }
                }
              }
            }
          }
        }

      }
    }
    |> OpenApiSpex.resolve_schema_modules() # Discover request/response schemas from path specs
  end
end
