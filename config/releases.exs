import Config

if config_env() == :prod do
  config :image_unmirrorer, ImageUnmirrorerWeb.Endpoint,
    http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
    secret_key_base: System.get_env("SECRET_KEY_BASE")
end
